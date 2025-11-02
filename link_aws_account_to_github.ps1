# link_aws_account_to_github.ps1

Set-Location -Path $PSScriptRoot

& "01_base_infra/01_iam/cfn_github_deployer.ps1"

Set-Location -Path $PSScriptRoot
