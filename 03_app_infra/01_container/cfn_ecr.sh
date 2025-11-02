#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStackPrefix=${PROJECT_NAME}-ecr
CfnTemplate=cfn_ecr.yml

deployCfnStack() {

  local ImageName=$1; shift

  # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/deploy.html
  aws cloudformation deploy \
    --template-file $CfnTemplate \
    --stack-name ${CfnStackPrefix}-${ImageName} \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        ProjectName=$PROJECT_NAME \
        ImageName=${ImageName}
}

deployCfnStack "todo-app"

popd > /dev/null
