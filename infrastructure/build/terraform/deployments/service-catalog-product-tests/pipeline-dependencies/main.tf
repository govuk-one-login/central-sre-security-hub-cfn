resource "aws_cloudformation_stack" "build_kms_key" {
  name          = "build-kms-key"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
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
  name          = "central-sre.build.sandpit.account.gov.uk"

  tags = {
    Environment = "build"
  }
}

resource "aws_cloudformation_stack" "ecs-cluster" {

  name          = "sc-product-test-ecs-cluster"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/ecs/ecs-cluster.yaml")

  parameters = {
    LoggingBucket           = "891376909120-centralised-logging-bucket"
    BaseUrl                 = aws_route53_zone.taskcat_test_ecs.name
    DeletionPolicy          = "Delete"
    UpdateReplacePolicy     = "Delete"
  }

  capabilities = ["CAPABILITY_AUTO_EXPAND"]
}

resource "aws_cloudformation_stack" "ecs-autoscaling" {

  name          = "sc-product-test-ecs-autoscaling"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/compute/ecs/ecs-autoscaling.yaml")

  parameters = {
    ECSCluster              = aws_cloudformation_stack.ecs-cluster.output["ECSClusterName"]
  }

    capabilities = ["CAPABILITY_AUTO_EXPAND"]
}