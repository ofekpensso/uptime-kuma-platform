# Terraform Backend

This root module bootstraps the Terraform remote backend for the project.

It creates an S3 bucket used to store Terraform state files.

## Resources

- S3 bucket for Terraform state
- S3 versioning
- S3 server-side encryption
- S3 public access block
- S3 ownership controls
- S3 lifecycle rule for old state versions

## State Locking

This project uses S3 native state locking with:

```hcl
use_lockfile = true