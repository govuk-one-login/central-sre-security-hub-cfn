module "vpc" {
  source           = "git@github.com:govuk-one-login/ipv-terraform-modules.git//secure-pipeline/vpc"
  stack_name       = "vpc-sc-product-test"
  allow_rules_file = "firewall_rules.txt"
  parameters = {
    CidrBlock                 = "10.0.0.0/16"
    AvailabilityZoneCount     = 2
    ZoneAEIPAllocationId      = "none"
    ZoneBEIPAllocationId      = "none"
    ZoneCEIPAllocationId      = "none"
    VpcLinkEnabled            = "Yes"
    LogsApiEnabled            = "Yes"
    CloudWatchApiEnabled      = "Yes"
    XRayApiEnabled            = "No"
    SSMApiEnabled             = "No"
    SecretsManagerApiEnabled  = "No"
    KMSApiEnabled             = "Yes"
    DynamoDBApiEnabled        = "No"
    S3ApiEnabled              = "Yes"
    SQSApiEnabled             = "Yes"
    SNSApiEnabled             = "No"
    KinesisApiEnabled         = "No"
    FirehoseApiEnabled        = "No"
    EventsApiEnabled          = "No"
    StatesApiEnabled          = "No"
    ECRApiEnabled             = "No"
    LambdaApiEnabled          = "Yes"
    CodeDeployApiEnabled      = "No"
    ExecuteApiGatewayEnabled  = "No"
    SSMParametersStoreEnabled = "No"
  }

  tags = {
    System = "Central SRE"
  }
}