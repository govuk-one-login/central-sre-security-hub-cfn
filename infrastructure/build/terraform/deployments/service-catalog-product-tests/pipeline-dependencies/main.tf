provider "aws" {
  region = "us-east-1"
  alias = "us"
}

resource "aws_cloudformation_stack" "build_kms_key" {
  name          = "build-kms-key"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
}

resource "aws_cloudformation_stack" "elb_access_logs_bucket" {
  name          = "elb-access-logs-bucket"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/storage/s3/elb-access-logs-bucket.yaml")
  
  parameters = {
      ELBAccessLogsBucketName  = "891376909120-elb-access-logs-bucket"
      S3ServerAccessLogsBucket = "891376909120-centralised-logging-bucket"
    }
}

resource "aws_iam_role" "empty_lambda" {
  name               = "iam-for-empty-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_ssm_parameter" "empty_lambdas_config" {
  name  = "empty-lambda-config"
  type  = "String"
  value = "CONFIG!!!"
}

resource "aws_cloudformation_stack" "empty_lambda_security_group" {
  name          = "sc-product-test-empty-lambda-sec-group"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/lambda/secgroup-https-tcp-vpc-egress.yaml")

  parameters = {
    VpcId   = module.vpc.stack_outputs.VpcId
    VpcCidr = module.vpc.stack_outputs.VpcCidr
  }

  capabilities = ["CAPABILITY_AUTO_EXPAND"]
}

resource "aws_cloudformation_stack" "empty_lambda" {

  depends_on = [aws_s3_object.empty_lambda]

  name          = "sc-product-test-empty-lambda"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/lambda/sam-cfn-template.yaml")

  parameters = {
    LambdaRole              = aws_iam_role.empty_lambda.name
    LambdaRoleNamePrefix    = ""
    SubnetIds               = "${module.vpc.stack_outputs.PrivateSubnetIdA},${module.vpc.stack_outputs.PrivateSubnetIdB}"
    SecurityGroupIds        = "${aws_cloudformation_stack.empty_lambda_security_group.outputs.SecurityGroup}"
    LambdaLogGroupRetention = 30
    SSMParameterArn         = aws_ssm_parameter.empty_lambdas_config.arn
    LambdaCodeUriBucket     = aws_s3_bucket.artifacts.id
    LambdaCodeUriKey        = aws_s3_object.empty_lambda.key
    LambdaPolicies          = ""
    Runtime                 = "python3.11"
    LambdaHandler           = "handler.process"
    Environment             = "build"
  }

  capabilities = ["CAPABILITY_AUTO_EXPAND"]
}

resource "aws_cloudformation_stack" "taskcat_test_sns" {
  name          = "sc-product-test-sns"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/messaging/sns/template.yaml")
  parameters = {
    TopicName = "taskcat-topic"
    KMSKeyId  = aws_cloudformation_stack.build_kms_key.outputs.KeyId
    System    = "taskcat"
  }
  capabilities = ["CAPABILITY_IAM"]
}

resource "aws_cloudformation_stack" "taskcat_lambada_secgroup" {
  name          = "sc-product-test-secgroup"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/lambda/secgroup-https-tcp-vpc-egress.yaml")
  parameters = {
    VpcId   = module.vpc.stack_outputs.VpcId
    VpcCidr = module.vpc.stack_outputs.VpcCidr
    System  = "taskcat"
  }
  capabilities = ["CAPABILITY_AUTO_EXPAND"]
}

resource "aws_route53_zone" "taskcat_test_ecs" {
  name          = "central-sre.build.account.gov.uk"

  tags = {
    Environment = "build"
  }
}

resource "aws_acm_certificate" "cert_us" {
  provider          = aws.us
  domain_name       = "central-sre.build.account.gov.uk"
  validation_method = "DNS"

  tags = {
    Environment = "build"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_us" {
  for_each = {
    for dvo in aws_acm_certificate.cert_us.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.taskcat_test_ecs.zone_id
}

resource "aws_acm_certificate_validation" "cert_us" {
  provider          = aws.us
  certificate_arn         = aws_acm_certificate.cert_us.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_us : record.fqdn]
}

resource "aws_ssm_parameter" "cert_us" {
  name  = "/build/Platform/ACM/Global/Certificate/Home/ARN"
  type  = "String"
  value = aws_acm_certificate.cert_us.arn
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "central-sre.build.account.gov.uk"
  validation_method = "DNS"

  tags = {
    Environment = "build"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.taskcat_test_ecs.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}

resource "aws_ssm_parameter" "hostedzone_cert" {
  name  = "/build/Platform/ACM/HostedZone/Certificate/Home/ARN"
  type  = "String"
  value = aws_acm_certificate.cert.arn
}

resource "aws_ssm_parameter" "hostedzone_id" {
  name  = "/build/Platform/Route53/HostedZone/Home"
  type  = "String"
  value = aws_route53_zone.taskcat_test_ecs.id
}

resource "aws_waf_ipset" "ipset" {
  name = "tfIPSet"

  ip_set_descriptors {
    type  = "IPV4"
    value = "192.0.7.0/24"
  }
}

resource "aws_waf_rule" "wafrule" {
  depends_on  = [aws_waf_ipset.ipset]
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"

  predicates {
    data_id = aws_waf_ipset.ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on = [
    aws_waf_ipset.ipset,
    aws_waf_rule.wafrule,
  ]
  name        = "tfWebACL"
  metric_name = "tfWebACL"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_waf_rule.wafrule.id
    type     = "REGULAR"
  }
}

resource "aws_ssm_parameter" "waf_acl" {
  name  = "/build/Platform/WAF/Global/ACL/ARN"
  type  = "String"
  value = aws_waf_web_acl.waf_acl.id
}

# ${AlertingTopicARN}/SNS/HighAlertNotificationTopic/ARN
# resource "aws_sns_topic" "taskcat" {
#   name = "ecs-cluster-sns-alert"
# }

# resource "aws_ssm_parameter" "waf_acl" {
#   name  = "build/Platform/WAF/Global/ACL/ARN"
#   type  = "String"
#   value = aws_waf_web_acl.waf_acl.id
# }

# resource "aws_cloudformation_stack" "ecs-cluster" {

#   name          = "sc-product-test-ecs-cluster"
#   template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/ecs/ecs-cluster.yaml")

#   parameters = {
#     LoggingBucket           = "891376909120-centralised-logging-bucket"
#     BaseUrl                 = aws_route53_zone.taskcat_test_ecs.name
#     DeletionPolicy          = "Delete"
#     UpdateReplacePolicy     = "Delete"
#   }

#   capabilities = ["CAPABILITY_AUTO_EXPAND"]
# }

# resource "aws_cloudformation_stack" "ecs-autoscaling" {

#   name          = "sc-product-test-ecs-autoscaling"
#   template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/ecs/ecs-autoscaling.yaml")

#   parameters = {
#     ECSCluster              = aws_cloudformation_stack.ecs-cluster.output["ECSClusterName"]
#     ContainerServiceName    = aws_cloudformation_stack.ecs-cluster.output["ContainerServiceName"]
#   }

#     capabilities = ["CAPABILITY_AUTO_EXPAND"]
# }