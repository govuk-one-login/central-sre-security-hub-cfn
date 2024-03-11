# SNS Subscription CloudFormation Template

This SNS Subscription Cloudformation template subscribes an endpoint to an Amazon SNS topic. For a subscription to be created, the owner of the endpoint must confirm the subscription.

Template conforms to AWS Security best practices:
  - Amazon Simple Notification Service (SNS) logging is enabled for the delivery status of notification messages sent to a topic for the endpoints.
  - SNS topic is encrypted with AWS Key Management Service (AWS KMS).

Templates are conformant with Security Hub rules:
   - Enforces: security hub rule(s) SNS01, SNS02.

Teams can input custom values into parameters to create or update stack:
  - Environment
  - Topic Arn
  - Subscriber Type
  - Subscriber Arn

### Amazon SNS 
Amazon SNS provides support to log the delivery status of notification messages sent to topics with the following endpoints:
 - Amazon Data Firehose
 - AWS Lambda
 - Platform application endpoint
 - Amazon Simple Queue Service

### Firehose Role
Amazon Data Firehose uses an IAM role to access the specified OpenSearch Serverless collection and streams. An IAM role is required when creating a Firehose stream.

## Notes

All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html

- To create multiple subsciptions to a topic please deploy multiple subscription stacks
- Metadata attribute enables you to associate structured data with a resource
- Subscription type pushes messages to the SNS topic