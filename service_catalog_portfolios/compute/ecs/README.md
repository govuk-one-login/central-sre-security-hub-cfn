# ECS Cluster Cloudformation Template

This ECS Cluster Cloudformation Template creates the necessary components to deploy an ECS Cluster, API Gateway and CloudFront Distribution. When used, this template will deploy a single ECS cluster for multiple Tasks/Services.
  
Please note that this template should be used from a wrapped cloudformation template.


### Template 1: [ecs-cluster.yaml](ecs-cluster.yaml)
Teams can input custom values into parameters to create or update stack:
- Environment
- Product
- Owner
- System
- Source 
- PermissionsBoundaryArn
- AlertingTopicARN
- APIGateWayLatencyAlertThreshold:
- LoggingBucket
- BaseUrl
- UseFargateSpot
- UpdateReplacePolicy
- DeletionPolicy
- RetentionInDays 
- LoggingDestinationArn
- UseDomainName

### Template 2: [ecs-autoscaling.yaml](ecs-autoscaling.yaml)
Teams can input custom values into parameters to create or update stack:
- ECSCluster
- ECSClusterMaxCapacity
- ECSClusterMinCapacity
- ContainerServiceName
- ECSServiceAverageCPUUtilizationTargetValue
- ECSServiceAverageCPUUtilizationScaleInCooldown
- ECSServiceAverageCPUUtilizationScaleOutCooldown
- ScaleOutPolicyCooldown
- ScaleOutPolicyMinAdjustmentMagnitude 
- ScaleOutPolicyMetricIntervalLowerBoundOne
- ScaleOutPolicyMetricIntervalUpperBoundOne
- ScaleOutPolicyScalingAdjustmentOne
- ScaleOutPolicyMetricIntervalLowerBoundTwo
- ScaleOutPolicyMetricIntervalUpperBoundTwo
- ScaleOutPolicyScalingAdjustmentTwo
- MetricIntervalLowerBoundThree
- ScaleOutPolicyScalingAdjustmentThree
- ScaleInPolicyCooldown
- ScaleInPolicyMetricIntervalUpperBound
- ScaleInPolicyScalingAdjustment