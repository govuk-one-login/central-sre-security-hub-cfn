resource "aws_cloudformation_stack" "build_kms_key" {
  name = "build-kms-key"
  template_body = file("${path.module}/../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
}
