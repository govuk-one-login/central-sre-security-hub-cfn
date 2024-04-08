module "service-catalog-pipeline" {
  source     = "git@github.com:govuk-one-login/ipv-terraform-modules//secure-pipeline/deploy-pipeline"
  template_url = "https://template-storage-templatebucket-1upzyw6v9cs42.s3.eu-west-2.amazonaws.com/sam-deploy-pipeline/template.yaml"
  stack_name = "service-catalog-pipeline"
  parameters = {
    SAMStackName               = "service-catalog"
    VpcStackName               = "na"
    Environment                = "dev"
    IncludePromotion           = "No"
    LogRetentionDays           = 30
    SigningProfileArn          = data.aws_cloudformation_stack.aws_signer.outputs["SigningProfileArn"]
    SigningProfileVersionArn   = data.aws_cloudformation_stack.aws_signer.outputs["SigningProfileVersionArn"]
    OneLoginRepositoryName     = "central-sre-security-hub-cfn"
  }

  tags_custom = {
    System = "Central SRE"
  }
}