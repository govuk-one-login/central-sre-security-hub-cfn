#!/bin/bash
region=eu-west-2
delay=45
taskcat test run --no-delete &> taskcat-output
cat taskcat-output
if grep -Fq "ERROR" taskcat-output
then
    echo "TaskCat threw an Error."
    taskcat test clean ALL --region eu-west-2
    exit 1
else
    echo ""
fi

if grep -Fq "WARN" taskcat-output
then
    echo "TaskCat issued a Warning."
    taskcat test clean ALL --region eu-west-2
    exit 1
else
    echo ""
fi

echo "giving security hub ${delay}s to run..."
sleep $delay
echo "continuing..."
stacksdir=stack-tests
mkdir ./$stacksdir
echo "Getting them stacks..."
# Search by custom tag (could also search by stack name prefix)
stacks=($(aws cloudformation describe-stacks \
    --region $region \
    --query "Stacks[?Tags[?Key == 'TestingFramework' && Value == 'taskcat-<hash-place-holder>']].{StackName: StackName}" \
    --output text))
for stack in "${stacks[@]}"
do 
    echo ""
    echo "Testing stack $stack"
    echo "=================================================================="
    stackdir=$stacksdir/$stack
    mkdir $stackdir
    echo "Getting the stack resources..."
    resources_as_string=$(aws cloudformation list-stack-resources \
        --stack-name $stack \
        --region eu-west-2 \
        --query 'StackResourceSummaries[*].{PhysicalResourceId: PhysicalResourceId, ResourceType: ResourceType}' \
        --output text| sort -u)

    IFS=$'\n' read -d '' -r -a resources <<<"$resources_as_string"

    # loop through the array
    for resource in "${resources[@]}"
    do
        PhysicalResourceId=`echo $resource | awk '{print $1}'`
        ResourceType=`echo $resource | awk '{print $2}'`

        response=`aws cloudcontrol get-resource --type-name ${ResourceType} --identifier ${PhysicalResourceId}`
        arn=`echo $response | jq -r '.ResourceDescription.Properties | fromjson.Arn'`
        
        if [[ $ResourceType != AWS::ApiGatewayV2::Stage ]] ;
        then
            # check that resource
            echo ""
            echo "Checking resource $PhysicalResourceId"
            aws securityhub get-findings \
            --region $region \
            --filters "{\"ResourceId\":[{\"Value\": \"$arn\", \"Comparison\":\"EQUALS\"}], \
                \"RecordState\":[{\"Value\":\"ACTIVE\", \"Comparison\":\"EQUALS\"}]}" \
            --query "Findings[*].{Title:Title, Description:Description, Status:Compliance.Status, Severity:Severity.Label}" \
            --output json > "./$stackdir/$PhysicalResourceId.json" 
            echo "Report written to:"
            echo "./$stackdir/$PhysicalResourceId.json"
        fi

    done # end loop through single stack resources
     echo "---------------------------------"
done # end loop through all stacks

# parse results

failure_flag=0

for f in $(find ./stack-tests -name '*.json')
do
  failure=$(cat $f | jq '.[] | select(.Status == "FAILED")')
  if [ -n "$failure" ]; then
    echo ""
    echo ""
    echo "${f} has failing Security Hub rules:"
    echo ""
    cat $f | jq '.[] | select(.Status == "FAILED")'
    echo ""
    echo ""
    failure_flag=1
  fi
done

# clean up the test stacks
taskcat test clean ALL --region eu-west-2

if [ "$failure_flag" -eq "1" ]; then
    exit 1
else
    echo ""
    echo "No Security Hub issues found"
    echo ""
fi