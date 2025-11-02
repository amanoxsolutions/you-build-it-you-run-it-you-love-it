#!/bin/bash -e

pushd "$(dirname $0)" > /dev/null
source ../../.env

CfnStack=${PROJECT_NAME}-github-deployer
CfnTemplate=cfn_github_deployer.yml

# Auto-detect Github repository path from git remote URL
GithubRepoUrl=$(git config --get remote.origin.url)

if [[ ! "$GithubRepoUrl" =~ "github" ]]; then
    echo "The remote origin URL is not a GitHub URL: $GithubRepoUrl"
    exit 1
fi

GithubRepoPath=$(echo "$GithubRepoUrl" | sed -e 's/.*github.*\.com[:/]//' -e 's/\.git$//')

if [ -z "$GithubRepoPath" ]; then
  echo "Could not determine Github repository path from remote URL: $GithubRepoUrl"
  exit 1
fi
echo "Auto-detected Github Repository Path: ${GithubRepoPath}"

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/deploy.html
aws cloudformation deploy \
  --template-file $CfnTemplate \
  --stack-name $CfnStack \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      ProjectName=$PROJECT_NAME \
      RepositoryPath=$GithubRepoPath

popd > /dev/null
