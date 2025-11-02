#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-alb
CfnTemplate=cfn_alb.yml

function cfn_export_val() {
   local param=$1
   aws cloudformation list-exports --query "Exports[?Name=='${PROJECT_NAME}-${param}'].Value" --output text
}

VpcId=$(cfn_export_val "vpc:VPC")

SubnetA=$(cfn_export_val "vpc:PublicSubnetA")
SubnetB=$(cfn_export_val "vpc:PublicSubnetB")
SubnetC=$(cfn_export_val "vpc:PublicSubnetC")

HostedZoneId=$(cfn_export_val "hosted-zone:HostedZoneId")
AcmCertificateArn=$(cfn_export_val "certificate:AcmCertificateArn")
CertificateDomain=$(cfn_export_val "certificate:CertificateDomain")

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
      HostedZoneId=$HostedZoneId \
      AcmCertificateArn=$AcmCertificateArn \
      DomainName=$CertificateDomain

popd > /dev/null
