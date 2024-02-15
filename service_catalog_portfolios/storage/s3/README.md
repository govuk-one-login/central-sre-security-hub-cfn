# S3 CloudFormation Templates

This folder contains the CloudFormation templates  to facilitate the creation fo S3 Buckets for logging purpises within your AWS Account. It includes:

1. [S3 Logging Bucket](s3-logging-bucket.yaml): This template creates an S3 Logging bucket for centralised logging within your AWS Account. The bucket is configured to subscribe to the centralised logging bucket via SQS by default.
2. [ELB Access Access Logs Bucket](elb-access-logs-bucket.yaml): This template creates an S3 Bucket to store ELB Access Logs. 

Both templates ensure compliance with various AWS Security Hub rules and security best practices, and provide customisable parameters to be used by teams:

- **Enforces:** security hub rule(s): S309, S310, S311, S312, S317, S318, S319
- **Supports:** security hub rule(s): S301, S302, S303, S304, S305, S306, S307, S308, S313, S314, S315, S316, S320, S321

## Instructions for use

Refer to [s3-logging-bucket.yaml](s3-logging-bucket.yaml) template and/or the [elb-access-logs-bucket.yaml](elb-access-logs-bucket.yaml) files for configuring custom parameters and resources, and setting specific policies for your required bucket(s). 

## Actions and Remediations

_All remediation actions were completed following the approach recommended by AWS https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html_

### **[S3.09 - s3-bucket-default-lock-enabled:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-default-lock-enabled.html)** 

This control checks if an Amazon S3 bucket has been configured to use Object Lock. The control fails if the S3 bucket isn't configured to use Object Lock.

**Remediation:** By providing a custom value for the mode parameter, the control passes - but only if S3 Object Lock uses the specified retention mode.

```
Parameters: 
    Mode: 
        Description: S3 Object Lock retention mode.
        Type: String
        AllowedValues:
            - GOVERNANCE
            - COMPLIANCE
        Default: COMPLIANCE
```
```
ELBAccessLogsBucket:
    Type: AWS::S3::Bucket
    [...]
    ObjectLockEnabled: true
      ObjectLockConfiguration:
        ObjectLockEnabled: Enabled
        Rule:
          DefaultRetention:
            Mode: !Ref Mode
            Days: !Ref LogRetentionInDays
      [...]
```

### **[S3.10 - s3-bucket-level-public-access-prohibited:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-level-public-access-prohibited.html)** 

This rule checks if S3 buckets have bucket level public access blocks applied. This control fails if any of the bucket level settings are set to `false`.

**Remediation:** S3 Block Public Access provides four settings. These should be configured to `true`:
```
PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true
```

### **[S3.11 s3-bucket-logging-enabled:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-logging-enabled.html)** 

This control checks whether S3 Event Notifications are enabled on the s3 bucket. The control fails if S3 Event Notifications are not enabled on a bucket.

**Remediation:** In your `s3-logging-bucket.yaml` template, define your `CslsS3Logs` condition, and configure notifications to subscribe to centralised logging.

```
Conditions:
  CslsS3Logs:
    !Or [
      !Equals [!Ref Environment, production],
      !Equals [!Ref Environment, integration],
      !Equals [!Ref Environment, staging],
      !Equals [!Ref Environment, build]
    ]
```

```
NotificationConfiguration:
    Fn::If: 
        - CslsS3Logs
        - QueueConfigurations: 
            - Event: "s3:ObjectCreated:*"
            Queue: arn:aws:sqs:eu-west-2:885513274347:cyber-security-s3-to-splunk-prodpython
        - Ref: AWS::NoValue
```

### **[S3.12 - s3-bucket-policy-grantee-check:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy-grantee-check.html):** 

This rule checks that the access granted by the Amazon S3 bucket is restricted by any of the AWS principals, federated users, service principals, IP addresses, or VPCs that you provide.

**Remediation:** Yet to be implemented. 

### **[S3.17 - s3-bucket-ssl-requests-only:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-ssl-requests-only.html)** 

This control checks if S3 buckets have policies that require requests to use SSL/TLS.
    
**Remediation:** To comply with the `s3-bucket-ssl-requests-only` rule, confirm that your bucket policies explicitly deny access to HTTP requests by configuring the `aws:SecureTransport` condition to `false`.

1. In the `s3-logging-bucket.yaml` template:
```
BucketPolicy:
    Type: AWS::S3::BucketPolicy
    [...]
        Statement:
          - Sid: AllowSSLRequestsOnly
            Action: s3:*
            Effect: Deny
            Principal: "*"
            Resource: !Join
              - ""
              - - "arn:aws:s3:::"
                - !Ref S3Bucket
                - "/*"
            Condition:
              Bool:
                aws:SecureTransport: false
```

2. In the `elb-access-logs-bucket.yaml` template:

```
BucketPolicy:
    Type: AWS::S3::BucketPolicy
    [...]
        Statement:
          - Sid: AllowSSLRequestsOnly
            Action: "s3:*"
            Effect: Deny 
            Principal: "*"
            Resource:
              - !Sub ${ELBAccessLogsBucket.Arn}
              - !Sub ${ELBAccessLogsBucket.Arn}/*
            Condition: 
              Bool:
                "aws:SecureTransport": "false"
```

### **[S3.18 - s3-bucket-versioning-enabled:](https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-versioning-enabled.html)** 

This rule checks if versioning is enabled for your S3 buckets. 

**Remediation:** Enable bucket versioning in the AWS::S3::Bucket resources: 

```
VersioningConfiguration:
    Status: Enabled
```

### **[S3.19 - s3-default-encryption-kms:](https://docs.aws.amazon.com/config/latest/developerguide/s3-default-encryption-kms.html)** 

This control checks if the S3 buckets are encrypted with AWS Key Management Service (AWS KMS).

**Remediation:** To encrypt an S3 bucket using SSE-KMS:

```
BucketEncryption:
ServerSideEncryptionConfiguration:
    - ServerSideEncryptionByDefault:
        SSEAlgorithm: "aws:kms"
        KMSMasterKeyID: !Ref KMSKey
```