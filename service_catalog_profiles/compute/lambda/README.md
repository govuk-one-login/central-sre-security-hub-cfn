# Lambda Function SAM CloudFormation Template

This Lambda SAM CloudFormation template creates an AWS Lambda function, an AWS Identity and Access Management (IAM) execution role, and event source mappings that trigger the function.

  - It checks if the Lambda function is configured with a function-level concurrent execution limit
  - It checks if the template is configured with a dead letter queue
  - It checks if the AWS Lambda function policy attached to the Lambda resource prohibits public access
  - It checks if a Lambda function is allowed access to a virtual private cloud (VPC)
  - It checks if Lambda has more than 1 availability zone associated with the Lambda

These templates conform to AWS Security best practices and is conformant with Security Hub rules:
   - Enforces: security hub rule(s) LMDA02, LMDA03, LMDA05.
   - Supports: security hub rule(s) LMDA04, LMDA06.

Teams can input custom values into parameters to create or update stack:
  - Environment
  - Function Log Subscription Filter
  - Lambda Code Uri Bucket
  - Lambda Code Uri Key
  - Lambda Concurrent Executions Limit
  - Lambda Handler
  - Lambda Log Group Retention
  - Lambda Policies
  - Lambda Role
  - LambdaRoleNamePrefix
  - Runtime
  - Secrets Manager Arn
  - Security Group Ids
  - Subnet Ids

## Security Group Templates

### Template 1: lambdafunction-securitygroup-dynamodb-s3-global-egress-template.yaml
    This Security Group template is for Security Group Ingress rules and Security Group Egress rules allows inbound traffic from vpc cidr to port 443 and allows outbound HTTPS traffic to Internet via port 443.
    PreFix List group has an outbound security group rule permitting instances from DynamoDB and S3 endpoints via port 443. 

    Teams can input custom values into parameters to create or update stack:
      - VPC Id
      - VPC Cidr

### Template 2: lambdafunction-securitygroup-vpc-egress-template.yaml
    This Security Group template is for Security Group Ingress rules and Security Group Egress VPC rules allows inbound traffic from vpc cidr to port 443, and allows outbound HTTPS traffic to vpc cidr from port 443.

    Teams can input custom values into parameters to create or update stack:
      - VPC Id
      - VPC Cidr

### Template 3: lambdafunction-securitygroup-global-egress-template.yaml
    This Security Group template is for Security Group Ingress rules and Security Group Egress Global rules allow inbound traffic from vpc cidr to port 443, and allow outbound HTTPS traffic to Internet globally via port 443.

    Teams can input custom values into parameters to create or update stack:
      - VPC Id
      - VPC Cidr

### Template 4: lambdafunction-securitygroup-ssh-tcp-global-egress-template.yaml
    This Security Group template is for Security Group Ingress rules and Security Group Egress Global rules 
    Allowing inbound tcp traffic from vpc cidr range on port 443. Outbound rules can be configured, default of 443 and tcp. Set ToPort, FromPort and IpProtocol to -1 to allow all protocols and ports.

    Teams can input custom values into parameters to create or update stack:
      - VPC Id
      - VPC Cidr
      - IP Protocol
      - From/To Port