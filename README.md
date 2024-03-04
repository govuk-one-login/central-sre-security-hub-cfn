# central-sre-security-hub-cfn
Security Hub compliant CloudFormation templates along with their associated infrastructure.

## Directory structure

### Directory structure - build

The build directory has everything neccersay to test and deploy the templates in the service_catalog_portfolios directory. Everything under here is deployed into `di-central-sre-build` AWS account.

### Directory structure - integration

The integration folder has everything neccersay to deploy the service catalog infrastructure into the `di-devplatform-service-catalog` AWS account. Service Catalog products and portfolios are deployed with the secure pipelines, but the portfolios are shared using terraform as this allows for the sharing with an entire OU or organisation. A cloudformation template gives the deployment role the permissions to allow sharing.

## Licence
[MIT License](LICENSE) 