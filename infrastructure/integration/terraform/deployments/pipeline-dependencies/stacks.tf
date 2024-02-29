module "github-identity" {
  source     = "git@github.com:govuk-one-login/ipv-terraform-modules.git//secure-pipeline/github-identity-provider"
  stack_name = "github-identity-build"
  parameters = {
    Environment = "build"
    System      = "Central SRE"
  }

  tags = {
    System = "Central SRE"
  }
}

module "aws-signer" {
  source     = "git@github.com:govuk-one-login/ipv-terraform-modules.git//secure-pipeline/aws-signer"
  stack_name = "aws-signer"
  parameters = {
    Environment = "build"
    System      = "Central SRE"
  }

  tags_custom = {
    System = "Central SRE"
  }
}