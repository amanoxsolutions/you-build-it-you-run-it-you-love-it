#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-service-todo
CfnTemplate=cfn_service_todo.yml

function cfn_export_val() {
   local param=$1
   aws cloudformation list-exports --query "Exports[?Name=='${PROJECT_NAME}-${param}'].Value" --output text
}

VpcId=$(cfn_export_val "vpc:VPC")

SubnetA=$(cfn_export_val "vpc:PublicSubnetA")
SubnetB=$(cfn_export_val "vpc:PublicSubnetB")
SubnetC=$(cfn_export_val "vpc:PublicSubnetC")

PermissionsBoundary=$(cfn_export_val "github-deployer:PermissionsBoundary")
DefaultTargetGroup=$(cfn_export_val "alb:DefaultTargetGroup")

ImageTag=$(git rev-parse --short HEAD)


# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/deploy.html
aws cloudformation deploy \
  --template-file $CfnTemplate \
  --stack-name $CfnStack \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      ProjectName=$PROJECT_NAME \
      VpcId=$VpcId \
      PublicSubnetIds="${SubnetA},${SubnetB},${SubnetC}" \
      PermissionsBoundary=$PermissionsBoundary \
      DefaultTargetGroup=$DefaultTargetGroup \
      ImageTag=$ImageTag

popd > /dev/null