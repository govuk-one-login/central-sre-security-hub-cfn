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

module "slack-notifications" {
  source     = "git@github.com:alphagov/di-ipv-terraform-modules.git//secure-pipeline/slack-notifications"
  stack_name = "di-devplatform-service-catalog-notifications"
  parameters = {
    SlackChannelId   = "C05TK3HH3RC" #skunkworks
    SlackWorkspaceId = "T8GT9416G"
  }

  tags_custom = {
    System = "Central SRE"
  }
}