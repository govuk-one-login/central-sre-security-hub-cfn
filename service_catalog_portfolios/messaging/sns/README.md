# SNS CloudFormation Template

This SNS Cloudformation template creates a topic to which notifications can be published.

Template conforms to AWS Security best practices:
  - Amazon Simple Notification Service (SNS) logging is enabled for the delivery status of notification messages sent to a topic for the endpoints.
  - SNS topic is encrypted with AWS Key Management Service (AWS KMS).

Templates are conformant with Security Hub rules:
  - Enforces: security hub rule(s) SNS01, SNS02.

Teams can input custom values into parameters to create or update stack:
  - Environment
  - Topic Name
  - Fifo Enabled
  - KMS Key Id
  - Successful Logging Percent
  - Xray Active Tracing

### SNS.1

This control checks whether an SNS topic is encrypted at rest using AWS KMS. The controls fails if an SNS topic doesn't use a KMS key for server-side encryption (SSE).
SSE encrypts messages as soon as Amazon SNS receives them. The messages are stored in encrypted form, and only decrypted when they are sent.

### SNS.2

This control checks whether logging is enabled for the delivery status of notification messages sent to an Amazon SNS topic for the endpoints. This control fails if the delivery status notification for messages is not enabled.


## Notes

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html

SNS Topic Policy follows least privilege principle. https://docs.aws.amazon.com/sns/latest/dg/sns-security-best-practices.html#ensure-topics-not-publicly-accessible 

Cross account should be enabled by creating a topic policy to deny all traffic aside from dedicated VPC Endpoint (solution out of ticket scope) https://docs.aws.amazon.com/sns/latest/dg/sns-security-best-practices.html#consider-using-vpc-endpoints-access-sns 
- Amazon SNS will send X-Ray segment data to topic owner account if the sampled flag in the tracing header is true.
- This template creates an empty SNS Topic, config is not connected to anything inbound or outbound
- Decoupled from SNS Subscription template
- Metadata attribute enables you to associate structured data with a resource