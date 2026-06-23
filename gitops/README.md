# GitOps Configuration

This directory contains the desired Kubernetes state managed by Argo CD.

## Ownership

Terraform manages:

* AWS infrastructure
* EKS cluster bootstrap
* Kubernetes StorageClass
* Argo CD installation
* The initial Argo CD root application

Argo CD manages:

* External Secrets Operator
* Uptime Kuma
* Monitoring components
* Application-specific Kubernetes resources
* Environment-specific Helm values

## Directory Structure

```text
gitops/
├── bootstrap/
├── applications/
├── values/
└── manifests/
```

### `bootstrap`

Contains the root Argo CD Application used to discover the child Application definitions.

### `applications`

Contains Argo CD Application resources for platform components and workloads.

### `values`

Contains environment-specific Helm values.

The application Helm chart remains in the application repository, while environment configuration remains in the platform repository.

### `manifests`

Contains Kubernetes resources that are managed by Argo CD but are not part of a Helm chart.

Examples include:

* ClusterSecretStore
* ExternalSecret
* Namespace configuration
* Supporting policies

## Repository Responsibilities

### Application repository

The application repository contains:

* Application source code
* Dockerfile
* CI workflow
* Reusable application Helm chart

### Platform repository

The platform repository contains:

* Terraform infrastructure
* Cluster bootstrap configuration
* Argo CD Applications
* Environment-specific values
* Platform component configuration

## Secrets

Secret values must never be committed to this directory.

Git contains only:

* Secret names
* AWS Secrets Manager references
* ExternalSecret definitions

Actual secret values remain in AWS Secrets Manager.
