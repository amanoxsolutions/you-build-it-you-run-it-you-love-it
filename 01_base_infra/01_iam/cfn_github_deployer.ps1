# cfn_github_deployer.ps1

Set-Location -Path $PSScriptRoot

# Load environment variables from .env
Get-Content "..\..\.env" | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        Set-Item -Path "env:$name" -Value $value
    }
}

$CfnStack = "${env:PROJECT_NAME}-github-deployer"
$CfnTemplate = "cfn_github_deployer.yml"

# Auto-detect Github repository path from git remote URL
$GithubRepoUrl = git config --get remote.origin.url

if ($GithubRepoUrl -notmatch "github") {
    Write-Host "The remote origin URL is not a GitHub URL: $GithubRepoUrl"
    exit 1
}

$GithubRepoPath = $GithubRepoUrl -replace '.*github.*\.com[:/]', '' -replace '\.git$',''

if ([string]::IsNullOrEmpty($GithubRepoPath)) {
    Write-Host "Could not determine Github repository path from remote URL: $GithubRepoUrl"
    exit 1
}
Write-Host "Auto-detected Github Repository Path: $GithubRepoPath"

aws cloudformation deploy `
    --template-file $CfnTemplate `
    --stack-name $CfnStack `
    --no-fail-on-empty-changeset `
    --capabilities CAPABILITY_NAMED_IAM `
    --parameter-overrides `
        ProjectName=$env:PROJECT_NAME `
        RepositoryPath=$GithubRepoPath
