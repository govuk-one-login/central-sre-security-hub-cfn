import json
import boto3

def lambda_handler(event, context):
    ssm_client = boto3.client("ssm")

    Response = ssm_client.get_parameter(Name="/aws/reference/secretsmanager/lambdasecrettest", WithDecryption=True)
    print(Response)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
