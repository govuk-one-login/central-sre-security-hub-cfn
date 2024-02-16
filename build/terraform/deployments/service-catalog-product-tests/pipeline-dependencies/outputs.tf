output "build_kms_key_id" {
  description = "The id of the build kms key."
  value = aws_cloudformation_stack.build_kms_key.outputs.KeyId
}

output "build_kms_key_arn" {
  description = "The arn of the build kms key."
  value = aws_cloudformation_stack.build_kms_key.outputs.KeyArn
}