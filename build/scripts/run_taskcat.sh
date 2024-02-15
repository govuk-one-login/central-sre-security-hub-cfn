#!/bin/bash
region=eu-west-2
delay=20
taskcat test run --no-delete
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
    #resources=($(sort -u resources)) gives us unique entries
    resources=($(aws cloudformation list-stack-resources \
        --stack-name $stack \
        --region $region \
        --query 'StackResourceSummaries[*].{PhysicalResourceId: PhysicalResourceId}' \
        --output text | sort -u))
    # loop through the array
    for resource in "${resources[@]}"
    do
        if [[ $resource == arn:aws:* ]] ;
        then
            # check that resource
            echo ""
            echo "Checking resource $resource"
            aws securityhub get-findings \
            --region $region \
            --filters "{\"ResourceId\":[{\"Value\": \"$resource\", \"Comparison\":\"EQUALS\"}] }" \
            --query "Findings[*].{Title:Title, Description:Description, Status:Compliance.Status, Severity:Severity.Label}" \
            --output json > "./$stackdir/$resource.json"
            echo "Report written to:"
            echo "./$stackdir/$resource.json"

        fi
    done # end loop through single stack resources
     echo "---------------------------------"
done # end loop through all stacks

# parse results

# clean up the test stacks
taskcat test clean ALL --region eu-west-2