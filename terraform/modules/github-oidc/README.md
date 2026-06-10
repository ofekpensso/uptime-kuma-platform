# GitHub OIDC Terraform Module

This module creates the AWS IAM resources required for GitHub Actions to authenticate to AWS using OpenID Connect.

The main purpose of this module is to allow the application repository CI pipeline to push Docker images to Amazon ECR without storing long-lived AWS access keys in GitHub Secrets.

## Resources Created

- `aws_iam_openid_connect_provider`
- `aws_iam_role`
- `aws_iam_policy`
- `aws_iam_role_policy_attachment`

## Current Use Case

In this project, GitHub Actions in the application repository builds a Docker image for Uptime Kuma and pushes it to Amazon ECR.

The workflow assumes an AWS IAM role using GitHub OIDC.

```text
GitHub Actions
    ↓
GitHub OIDC token
    ↓
AWS IAM Role
    ↓
Temporary AWS credentials
    ↓
Push Docker image to Amazon ECR
Why OIDC?

OIDC avoids storing static AWS credentials such as:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

Instead, GitHub Actions receives short-lived credentials only during workflow execution.

This improves security and follows a better CI/CD authentication model.

Trust Policy

The IAM role trust policy is restricted to a specific GitHub repository and branch.

Example:

repo:ofekpensso/uptime-kuma-app:ref:refs/heads/main

This means only workflows running from the allowed repository and branch can assume the role.

The role is not open to all GitHub repositories or all branches.

Permissions

The IAM policy follows least privilege for the current CI use case.

It allows GitHub Actions to push images only to the configured ECR repository.

The policy allows:

Getting an ECR authorization token
Checking layer availability
Uploading image layers
Completing image uploads
Pushing image manifests
Reading repository and image metadata

ecr:GetAuthorizationToken requires Resource = "*", while repository-specific actions are scoped to the provided ECR repository ARN.

Inputs
Name	Description	Type	Default
github_owner	GitHub username or organization that owns the repository	string	n/a
github_repository	GitHub repository name allowed to assume the role	string	n/a
github_branch	GitHub branch allowed to assume the role	string	main
role_name	IAM role name for GitHub Actions	string	n/a
policy_name	IAM policy name for ECR push permissions	string	n/a
ecr_repository_arn	ARN of the ECR repository GitHub Actions can push to	string	n/a
tags	Tags to apply to IAM resources	map(string)	{}
Outputs
Name	Description
github_actions_role_arn	IAM role ARN assumed by GitHub Actions
github_oidc_provider_arn	GitHub OIDC provider ARN
github_actions_policy_arn	IAM policy ARN attached to the GitHub Actions role
GitHub Actions Requirements

The workflow must include minimal permissions:

permissions:
  id-token: write
  contents: read

id-token: write allows GitHub Actions to request an OIDC token.

contents: read allows the workflow to check out the repository code.

The workflow should use the generated role ARN:

- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::<account-id>:role/<role-name>
    aws-region: us-east-1
Security Notes

This module does not create or store AWS access keys.

Authentication is based on short-lived credentials issued through AWS STS.

The trust policy should stay as restrictive as possible:

Restrict by repository
Restrict by branch
Do not allow wildcard access unless needed
Prefer push to ECR only from main
Production Notes

For production environments, consider:

Separate IAM roles per environment
Separate repositories or ECR repositories per environment
Stricter branch restrictions
GitHub Environments with required reviewers
Separate workflows for pull request validation and image publishing
No image push from untrusted pull requests
Git Safety

This module does not contain secrets.

Safe to commit:

main.tf
variables.tf
outputs.tf
README.md

Do not commit:

Terraform state files
real terraform.tfvars
real backend.tf
AWS credentials