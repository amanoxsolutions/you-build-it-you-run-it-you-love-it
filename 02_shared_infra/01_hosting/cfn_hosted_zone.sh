#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-hosted-zone
CfnTemplate=cfn_hosted_zone.yml

RootDomain=$1

if [ -z "$RootDomain" ]; then
  echo "Error: \"RootDomain\" is not given. Please provide it as the 1st argument of the script, e.g. \"company.com\""
  exit 1
fi

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/deploy.html
aws cloudformation deploy \
  --template-file $CfnTemplate \
  --stack-name $CfnStack \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      ProjectName=$PROJECT_NAME \
      RootDomain=$RootDomain

popd > /dev/null
