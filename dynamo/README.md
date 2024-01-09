# Problem 

## I want to create dynamo DB templates that conform to AWS security best practices

# Actions

## - Using a unque KMS key to encrypt each database

## - Using CloudTrail to monitor KMS key usage

## - Tagging Dynamo Resources following GDS standard

## - Pass Security Hub checks

# To Do 

## - Utilize S3 template to store the CloudTrail Logs

## - Once KMS template uploaded to s3 then use the KMS template to create the dynamo encryption key

## - Get the If statements working

## - Add more tagging for IAM role and Cloudtrail

## - test both the single and compisite key cases in Security Hub.