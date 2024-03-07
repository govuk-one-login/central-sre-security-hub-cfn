# Secrets Manager CloudFormation Template

This Secrets Manager CloudFormation template creates a secret in an encrypted form in Secrets Manager. 

Template conforms to AWS Security best practices:
  - AWS Secrets Manager secret has rotation enabled
  - All secrets in AWS Secrets Manager are encrypted using the AWS managed key (aws/secretsmanager) or a customer managed key that was created in AWS Key Management Service (AWS KMS)
  - AWS Secrets Manager secrets have been rotated in the past specified number of days
  - AWS Secrets Manager secrets have been accessed within a specified number of days

Templates are conformant with Security Hub rules:
  - Enforces: security hub rule(s) SCRTS01, SCRTS03, SCRTS05.
  - Supports: security hub rule(s) SCRTS04.

Teams can input custom values into parameters to create or update stack:
  - Secret Name
  - Secret Description
  - Periodic Rotation Days
  - Key Rotation Lambda ARN
  - Kms Key Id
  - Notify After Unused For Days
  - Environment

## Secrets Manager Rotation Schedule
  The Secrets Manager Rotation Schedule sets the rotation schedule and Lambda rotation function for a secret, it determines how often the secret will automatically rotate. 
  An example of this is in [Sample rotation](sample-rotation.py).

## Secrets Manager Permission
  This grants an AWS service or another account permission to use a function. You can apply the policy at the function level, or specify a qualifier to restrict access to a single version or alias. If you use a qualifier, the invoker must use the full Amazon Resource Name (ARN) of that version or alias to invoke the function.