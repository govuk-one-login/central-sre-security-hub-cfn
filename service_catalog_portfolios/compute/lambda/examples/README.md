# Lambda Function using SSM Parameter Example

Here you'll find a demo Lambda function for use with Service Catalog Lambda template. The template will need to pass the same environment variables every time it is used, and will need to pull config from Secrets Manager via SSM Parameter.

## Steps:
1. Create a Secret via AWS CLI
  - Connect to AWS CLI via SSO Login
  - The following create-secret example creates a secret with two key-value pairs:
```bash
        aws secretsmanager create-secret \
        --name MyTestSecret \
        --description "My test secret created with the CLI." \
        --secret-string "{\"user\":\"EXAMPLE-USER\",\"password\":\"EXAMPLE-PASSWORD\"}"
```
  - To check if it has successfully created, login to AWS Management Console > Secrets Manager > Secrets

2. Create IAM Role
  - Login to AWS Management Console > IAM > Roles. Create New Role, adding permissions for "AmazonSSMFullAccess" and "SecretsManagerReadWrite".
  
  `NOTE`: Verify that you have permissions for Secrets Manager and Systems Manager, if you don't have permission to access that secret, the function fails. 

3. Create Lambda Function
   - Function will read from SSM Parameter
    - Import Boto3 Library
    - Reference a secret:
        - This can be done by using the AWS CLI, AWS Tools for Windows PowerShell, or the SDK
        - When you reference a Secrets Manager secret, the name must begin with the following reserved path: `/aws/reference/secretsmanager/`
        - By specifying this path, Systems Manager knows to retrieve the secret from Secrets Manager instead of Parameter Store. Below is an example:
      ```bash
      /aws/reference/secretsmanager/CFCreds1
      ```
    - get_parameter syntax:
```bash
        response = client.get_parameter(
        Name='string',
        WithDecryption=True|False
    )
```

For more information, see https://docs.aws.amazon.com/systems-manager/latest/userguide/integration-ps-secretsmanager.html

## Notes
  Parameter Store functions as a pass-through service for references to Secrets Manager secrets. Parameter Store doesn't retain data or metadata about secrets.