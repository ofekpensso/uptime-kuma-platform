# Secrets Manager Terraform Module

This module creates an AWS Secrets Manager secret and generates a secure random password using Terraform.

The module is used to store application and infrastructure credentials in AWS Secrets Manager so they can later be consumed by Kubernetes workloads through External Secrets Operator.

## Resources Created

* `aws_secretsmanager_secret`
* `random_password`

## Current Use Case

In this project, the module is used to generate and store the RDS database password.

The generated password is passed to the RDS module and later written into a Secrets Manager secret version as part of a JSON credentials object.

## Inputs

| Name                      | Description                                             | Type          | Default |
| ------------------------- | ------------------------------------------------------- | ------------- | ------- |
| `name`                    | Name of the Secrets Manager secret                      | `string`      | n/a     |
| `description`             | Description of the secret                               | `string`      | `null`  |
| `recovery_window_in_days` | Number of days before the secret is permanently deleted | `number`      | `7`     |
| `password_length`         | Length of the generated password                        | `number`      | `24`    |
| `tags`                    | Tags to apply to the secret                             | `map(string)` | `{}`    |

## Outputs

| Name         | Description                | Sensitive |
| ------------ | -------------------------- | --------- |
| `secret_id`  | Secrets Manager secret ID  | No        |
| `secret_arn` | Secrets Manager secret ARN | No        |
| `password`   | Generated password         | Yes       |

## Security Notes

The password is generated during Terraform apply and stored in Terraform state.

Even though the password output is marked as sensitive, sensitive values are still stored in the Terraform state file. For this reason, Terraform state must be stored securely and must never be committed to Git.

In this project, the Terraform state is stored remotely in an S3 backend.

## Git Safety

This module does not contain hardcoded secrets.

The generated password is not stored in the Terraform code. It is created during `terraform apply` and stored in:

* Terraform state
* AWS Secrets Manager
* RDS master password configuration

Do not commit:

* `terraform.tfstate`
* `terraform.tfstate.backup`
* `.terraform/`
* `*.tfplan`
* real `terraform.tfvars`
* real `backend.tf`
