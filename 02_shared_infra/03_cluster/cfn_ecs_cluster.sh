#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-ecs-cluster
CfnTemplate=cfn_ecs_cluster.yml

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/deploy.html
aws cloudformation deploy \
  --template-file $CfnTemplate \
  --stack-name $CfnStack \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      ProjectName=$PROJECT_NAME

popd > /dev/null
