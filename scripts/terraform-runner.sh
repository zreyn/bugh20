#!/bin/bash
set -eu

# eval $(gimme-aws-creds)

cd repo/terraform

temp_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::078557663622:role/OrganizationAccountAccessRole" \
                    --role-session-name "$(whoami)-session")

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

terraform init
rm -rf ./tfplan.out

terraform plan --out tfplan.out
terraform apply -auto-approve tfplan.out
