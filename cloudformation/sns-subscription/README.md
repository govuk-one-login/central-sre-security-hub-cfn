# Problem 

I want to create SNS publisher or subscriber connections templates that conform to AWS security best practices.

# Actions

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html

### SNS.1
SNS topics should be encrypted at-rest using AWS KMS

### SNS.2
Logging of delivery status should be enabled

---
## Notes

- Supports one subscription and one publisher

- Amazon SNS will send X-Ray segment data to topic owner account if the sampled flag in the tracing header is true.



