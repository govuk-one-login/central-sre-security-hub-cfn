# Problem 

I want to create SNS templates that conform to AWS security best practices.

# Actions

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html

SNS Topic Policy follows least privalage principle. https://docs.aws.amazon.com/sns/latest/dg/sns-security-best-practices.html#ensure-topics-not-publicly-accessible 

### SNS.1
SNS topics should be encrypted at-rest using AWS KMS

### SNS.2
Logging of delivery status should be enabled

---
## Notes

- Supports cross account many subscription and many publisher

- Amazon SNS will send X-Ray segment data to topic owner account if the sampled flag in the tracing header is true.

## Test Cases

- test multiple subscribers

- test attempted subscription from a resource not defined in the Topic policy to check it fails


