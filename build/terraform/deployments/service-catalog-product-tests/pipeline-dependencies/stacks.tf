# module "aws-signer" {
#   source     = "git@github.com:govuk-one-login/ipv-terraform-modules.git//secure-pipeline/aws-signer"
#   stack_name = "aws-signer-pipeline"
#   parameters = {
#     Environment = "build"
#     System      = "Central SRE"
#   }

#   tags_custom = {
#     System = "Central SRE"
#     Owner = "Central-SRE"
#   }
# }