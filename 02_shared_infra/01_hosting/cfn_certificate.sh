#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-certificate
CfnTemplate=cfn_certificate.yml

HostedZoneId=$(aws cloudformation list-exports --query "Exports[?Name=='${PROJECT_NAME}-hosted-zone:HostedZoneId'].Value" --output text)

DomainName=$1

if [ -z "$DomainName" ]; then
  echo "Error: DomainName is not given. Please provide it as the 1st argument of the script, e.g. \"www.company.com\""
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
      HostedZoneId=$HostedZoneId \
      DomainName=$DomainName

popd > /dev/null
