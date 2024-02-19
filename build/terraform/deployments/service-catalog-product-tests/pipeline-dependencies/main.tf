resource "aws_cloudformation_stack" "build_kms_key" {
  name          = "build-kms-key"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
}

resource "aws_iam_role" "empty_lambda" {
  name               = "iam-for-empty-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#TODO should be replaced by SSM parameter as part of SW-184
resource "aws_secretsmanager_secret" "empty_lambdas_config" {}

resource "aws_cloudformation_stack" "empty_lambda_security_group" {
  name          = "sc-product-test-empty-lambda-sec-group"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/compute/lambda/lambdafunction-securitygroup-vpc-egress-template.yaml")

  parameters = {
    VpcId = module.vpc.stack_outputs.VpcId
    VpcCidr = module.vpc.stack_outputs.VpcCidr
  }

  capabilities = ["CAPABILITY_AUTO_EXPAND"]
}

resource "aws_cloudformation_stack" "empty_lambda" {

  depends_on = [ aws_s3_object.empty_lambda ]

  name          = "sc-product-test-empty-lambda"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/compute/lambda/lambdafunction-sam-cfn-template.yaml")

  parameters = {
    LambdaRole           = aws_iam_role.empty_lambda.name
    LambdaRoleNamePrefix = ""
    SubnetIds = "${module.vpc.stack_outputs.PrivateSubnetIdA},${module.vpc.stack_outputs.PrivateSubnetIdB}"
    SecurityGroupIds = "${aws_cloudformation_stack.empty_lambda_security_group.outputs.SecurityGroup}"
    LambdaLogGroupRetention = 30
    SecretsManagerArn = aws_secretsmanager_secret.empty_lambdas_config.arn
    LambdaCodeUriBucket = aws_s3_bucket.artifacts.id
    LambdaCodeUriKey = aws_s3_object.empty_lambda.key
    LambdaPolicies = ""
    Runtime = "python3.11"
    LambdaHandler = "handler.process"
    Environment = "build"
  }

   capabilities = ["CAPABILITY_AUTO_EXPAND"]
}