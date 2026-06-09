# ECR Terraform Module

This module creates an Amazon Elastic Container Registry repository for storing Docker images.

## Resources Created

- `aws_ecr_repository`
- `aws_ecr_lifecycle_policy`

## Current Use Case

In this project, the ECR repository stores the Docker image used by the Uptime Kuma application.

The CI pipeline will build the Docker image, tag it with the Git commit SHA, and push it to this repository.

## Configuration

The development environment uses:

- Repository name: `uptime-kuma`
- Image tag mutability: `IMMUTABLE`
- Scan on push: enabled
- Force delete: enabled
- Lifecycle policy: keep only the last 10 tagged images
- Delete untagged images after 1 day
- Encryption: AES256

## Why Immutable Tags?

Immutable image tags prevent accidentally overwriting an existing image tag.

Instead of pushing generic tags such as `latest`, the CI pipeline should push deterministic tags such as:

```text
sha-a1b2c3d



This makes deployments more reliable and easier to debug.

Cost Optimization

The lifecycle policy keeps only the last configured number of tagged images and deletes untagged images after one day.

This prevents old build artifacts from accumulating and increasing storage costs.

Destroy Behavior

force_delete = true allows Terraform to delete the ECR repository even if it contains images.

This is useful for development environments where terraform destroy should clean everything automatically.

For production environments, consider setting this to false.

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