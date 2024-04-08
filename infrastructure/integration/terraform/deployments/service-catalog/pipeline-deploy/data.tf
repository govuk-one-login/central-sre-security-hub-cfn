data "aws_cloudformation_stack" "aws_signer" {
  name = "aws-signer"
}

data "aws_iam_roles" "deploy_role" {
  name_regex = "PL-service-catalog-pipeline-DeployRole.*"
}

data "aws_iam_policy_document" "service_catalog" {
  
  statement {
    sid    = "ServiceCatlogPerms"

    effect = "Allow"

    actions = [
      "cloudformation:ValidateTemplate",
      "codestar-connections:PassConnection",
      "codestar-connections:UseConnection",
      "connections:UseConnection",
      "servicecatalog:AssociateProductWithPortfolio",
      "servicecatalog:CreatePortfolio",
      "servicecatalog:CreatePortfolioShare",
      "servicecatalog:CreateProduct",
      "servicecatalog:DeletePortfolio",
      "servicecatalog:DeletePortfolioShare",
      "servicecatalog:DeleteProduct",
      "servicecatalog:DisassociateProductFromPortfolio",
      "servicecatalog:UpdatePortfolio",
      "servicecatalog:UpdatePortfolioShare",
      "servicecatalog:UpdateProduct"
    ]

    resources = ["*"]

  }
}