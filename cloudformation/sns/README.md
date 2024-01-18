# Problem 

I want to create SNS templates that conform to AWS security best practices.

# Actions

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html

### SNS.1
SNS topics should be encrypted at-rest using AWS KMS

Solution: Tables should be in Pay Per Request Mode or be in provisioned mode with auto scaling. 

### SNS.2
DynamoDB tables have point in time recovery enabled.

---
## Notes

- Supports a single subscription for each of the following endpoint types:
    - http/https
    - email
    - SNS
    - SMS
    - Application
    - Lambda
    - Firehose

- Supports up to two subscriptions for:
    - sqs

