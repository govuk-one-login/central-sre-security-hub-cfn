resource "aws_cloudformation_stack" "build_kms_key" {
  name          = "build-kms-key"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "di-central-sre-build-artifacts"
}



resource "aws_iam_role" "iam_for_empty_lambda" {
  name               = "iam-for-empty-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#TODO should be replaced by SSM parameter as part of SW-184
resource "aws_secretsmanager_secret" "empty_lambdas_config" {}

resource "aws_cloudformation_stack" "empty_lambda_security_group" {
  name          = "sc-product-test-empty-lambda-sec-group"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/compute/lambda/lambdafunction-securitygroup-vpc-egress-template.yaml")

  parameters = {
    VpcId = module.vpc.vpc_stack_outputs.VpcId
    VpcCidr = module.vpc.vpc_stack_outputs.VpcCidr
  }
}

resource "aws_cloudformation_stack" "empty_lambda" {
  name          = "sc-product-test-empty-lambda"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/compute/lambda/lambdafunction-sam-cfn-template.yaml")

  parameters = {
    LambdaRole           = aws_iam_role.iam_for_empty_lambda.arn
    LambdaRoleNamePrefix = ""
    SubnetIds = [
      module.vpc.vpc_stack_outputs.PrivateSubnetIdA, 
      module.vpc.vpc_stack_outputs.PrivateSubnetIdB
      ]
    SecurityGroupIds = [aws_cloudformation_stack.empty_lambda_security_group.outputs.SecurityGroup]
    LambdaLogGroupRetention = 30
    SecretsManagerArn = aws_secretsmanager_secret.empty_lambdas_config.arn

  }
}