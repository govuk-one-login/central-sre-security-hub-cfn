resource "aws_iam_policy" "service_catalog" {
  name        = "service_catalog_policy"
  description = "Service Catalog policy for GitHub"
  policy      = data.aws_iam_policy_document.service_catalog.json
}

resource "aws_iam_role_policy_attachment" "service_catalog" {
  for_each = data.aws_iam_roles.deploy_role.names 
  
  role       = each.value
  policy_arn = aws_iam_policy.service_catalog.arn
}

