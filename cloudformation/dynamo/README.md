# Problem 

### I want to create dynamo DB templates that conform to AWS security best practices.

# Actions

### All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-1 

### DynamoDB.1: DynamoDB tables should automatically scale capacity with demand.

### &nbsp;&nbsp;&nbsp;&nbsp; Solution: Tables should be in Pay Per Request Mode or be in provissioned mode with auto scaling. 

### DynamoDB.2: DynamoDB tables have point in time recovery enabled.

### DynamoDB.4: DynamoDB tables should provide a backup plan.

### &nbsp;&nbsp;&nbsp;&nbsp; Solution: Utilizing tagging strategies for AWS Backup.

## Other approaches taken

### - Requires a KMS key to encrypt each database

### - Tagging Dynamo Resources following GDS standard

## Notes

### - This template does not support global secondary indexes

### - DynamoDB.6 Deletion protection is enabled on all tabled was not followed as it prevents team flexibility and experimentation. Potential to turn this rule on for prod only. 

### - There are no constraints to prevent users from inputting Minimum capacity values greater than the Maximum capacity values. This section is prone to user error. The description has been added to reduce this risk.