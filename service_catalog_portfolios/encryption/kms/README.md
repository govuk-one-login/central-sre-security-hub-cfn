# KMS Key CloudFormation Template

This KMS Key Cloudformation template specifies a KMS key in AWS Key Management Service. You can use this resource to create symmetric encryption KMS keys, asymmetric KMS keys for encryption or signing, and symmetric HMAC KMS keys.

Template conforms to AWS Security best practices:
  - Automatic key rotation is enabled for each key and matches to the key ID of the customer created AWS KMS key. 

Templates are conformant with Security Hub rules:
  - Enforces: security hub rule(s) KEYMGMT02.

Teams can input custom values into parameters to create or update stack:
  - Environment
  - Allowed Accounts
  - Alert Topic ARN
  - Service
  - Key Spec
  - Key Usage
  - Deletion Policy
  - Update Replace Policy

### KMS Key Rotation

AWS KMS enables customers to rotate the backing key, which is key material stored in AWS KMS and is tied to the key ID of the KMS key. It's the backing key that is used to perform cryptographic operations such as encryption and decryption. 

Automated key rotation currently retains all previous backing keys so that decryption of encrypted data can take place transparently.

### Key Spec and Usage

- This template uses various AWS services that can use the CMK (Custom Master Key)
- Key Spec > specifies the type of KMS key to create
- Key usage determines the cryptographic operations for which you can use the KMS key

## Notes

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/kms-controls.html#kms-4

- CloudFormation deletes the resource and all its content if applicable during stack deletion.