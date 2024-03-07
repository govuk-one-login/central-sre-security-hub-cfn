# DynamoDB CloudFormation Template

Template conforms to AWS Security best practices:
  - Amazon DynamoDB tables or global secondary indexes can process read/write capacity using on-demand mode or provisioned mode with auto scaling enabled.
  - Amazon DynamoDB table is present in AWS Backup Plans
  - A recovery point was created for Amazon DynamoDB Tables within the specified period.
  - Amazon DynamoDB tables are protected by a backup plan.
  - Point-in-time recovery (PITR) is enabled for Amazon DynamoDB tables.
  - Amazon DynamoDB table is present in AWS Backup Plans.
  - Checks if provisioned DynamoDB throughput is approaching the maximum limit for your account.
  - Amazon DynamoDB tables are encrypted and checks their status.

Templates are conformant with Security Hub rules:
  - Enforces: security hub rule(s) DYDB01, DYDB02, DYDB09, DYDB10, DYDB03, DYDB04.
  - Supports: security hub rule(s) DYDB05, DYDB11.

Teams can input custom values into parameters to create or update stack:
  - Dynamo Table Name
  - Contributor Insights Enabling
  - Table KMS Key
  - Provisioned Throughput Enabling
  - Target Read Capacity
  - Max Read Capacity
  - Min Read Capacity
  - Target Write Capacity
  - Max Write Capacity
  - Min Write Capacity
  - Primary Key Name
  - Primary Key Type
  - Sort Key Enabling
  - Sort Key Name
  - Sort Key Type
  - Time To Live Enabling
  - Time To Live Column Name
  - Environment

### DynamoDB.1 
  This control checks whether an Amazon DynamoDB table can scale its read and write capacity as needed. The control fails if the table doesn't use on-demand capacity mode or provisioned mode with auto scaling configured.
  - DynamoDB tables should automatically scale capacity with demand.
  - Solution: Tables should be in Pay Per Request Mode or be in provisioned mode with auto scaling. 

### DynamoDB.2
  This control checks whether point-in-time recovery (PITR) is enabled for an Amazon DynamoDB table.
  - Automates backup for DynamoDB Tables
  - Has PITR enabled to be restored to any point in time in the last 35 days

### DynamoDB.4
  This control evaluates whether an Amazon DynamoDB table in ACTIVE state is covered by a backup plan. The control fails if the DynamoDB table isn't covered by a backup plan.
  - Solution: Utilising tagging strategies for AWS Backup.

### Other approaches taken
  - Requires a KMS key to encrypt each database
  - Tagging Dynamo Resources following GDS standard

## Notes
  All remediation actions were completed following the approach recommended by AWS. https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-1 
  - DynamoDB.6 Deletion protection is enabled on all tables was not followed as it prevents teams flexibility and experimentation [Potential to turn this rule on for prod only]
  - There are no constraints to prevent users from inputting Minimum capacity values greater than the Maximum capacity values. This section is prone to user error [description has been added to reduce this risk]
  - DYDB01, DYDB05 only needs to be satisfied if Provisioned Throughput is being applied. It will need to be parameterised and the use of the AutoScaling service should be conditional.
  - DYDB02, DYDB09 and DYDB10 [should all be addressed by AWS Backup]