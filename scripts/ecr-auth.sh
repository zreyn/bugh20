#!/bin/bash
set -eu

temp_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::078557663622:role/OrganizationAccountAccessRole" \
                    --role-session-name "$(whoami)-session")

unset AWS_SECURITY_TOKEN
unset AWS_ROLE_ARN

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

aws ecr get-login-password --region us-east-2
