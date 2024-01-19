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

- Supports many subscriptions

- Amazon SNS will vend X-Ray segment data to topic owner account if the sampled flag in the tracing header is true.

## Approach

- subscriptions can be defined inside the lambdas or other subscription types. For this solution the user inputs subscribers to determine the SNS Topic Policy to provide extra secrity for what can publish or subscribe to a topic.

- No support for http/(s) yet as difficult to configure into the topic policy

- Support for publishers needs to be optional not manitory

