# Kubernetes StorageClass Module

This Terraform module creates a Kubernetes `StorageClass` for dynamic Amazon EBS volume provisioning through the AWS EBS CSI Driver.

The module does not create an EBS volume directly. It defines how Kubernetes should create EBS volumes when an application creates a `PersistentVolumeClaim`.

## Purpose

The module provides a reusable and predictable storage configuration for applications running on Amazon EKS.

The expected flow is:

```text
Terraform creates StorageClass
        ↓
Helm creates PersistentVolumeClaim
        ↓
AWS EBS CSI Driver creates PersistentVolume
        ↓
AWS EBS CSI Driver creates and attaches an EBS volume
        ↓
The volume is mounted into the application Pod
```

## Resources Created

The module creates:

* One Kubernetes `StorageClass`

The module does not directly create:

* Amazon EBS volumes
* Kubernetes PersistentVolumes
* Kubernetes PersistentVolumeClaims
* Application Pods
* Kubernetes namespaces

PersistentVolumes and EBS volumes are created dynamically only when an application requests storage through a PVC.

## Default Configuration

The module defaults to:

| Setting              |                Default | Description                                              |
| -------------------- | ---------------------: | -------------------------------------------------------- |
| StorageClass name    |                  `gp3` | Name requested by application PVCs                       |
| Provisioner          |      `ebs.csi.aws.com` | AWS EBS CSI Driver                                       |
| EBS volume type      |                  `gp3` | Type of dynamically created EBS volume                   |
| Encryption           |                 `true` | Encrypt newly created EBS volumes                        |
| Filesystem           |                 `ext4` | Filesystem created on the volume                         |
| Reclaim policy       |               `Retain` | Safe reusable-module default                             |
| Volume binding mode  | `WaitForFirstConsumer` | Wait until a Pod is scheduled before creating the volume |
| Volume expansion     |                 `true` | Allow PVC size increases                                 |
| Default StorageClass |                `false` | Applications must request this class explicitly          |

The development environment overrides the reclaim policy to `Delete`.

## Why `WaitForFirstConsumer`?

Amazon EBS volumes belong to a single Availability Zone.

With `WaitForFirstConsumer`, Kubernetes waits until a Pod is scheduled before creating the volume. This allows the EBS CSI Driver to create the EBS volume in the same Availability Zone as the selected worker node.

Without this behavior, a volume could be created in a different Availability Zone from the Pod and would not be attachable to the node.

## Why the Module Does Not Create EBS Directly

Creating a static EBS volume through Terraform would also require managing:

* The Availability Zone of the volume
* A Kubernetes PersistentVolume
* The EBS volume ID inside the PersistentVolume
* The binding between the PersistentVolume and PersistentVolumeClaim
* Replacement behavior after the EKS cluster is recreated

Dynamic provisioning avoids this manual lifecycle.

The application requests storage using a PVC, and the EBS CSI Driver creates the correct EBS volume in the required Availability Zone.

## Usage

```hcl
module "gp3_storage_class" {
  source = "../../modules/storage-class"

  name                   = "gp3"
  storage_provisioner    = "ebs.csi.aws.com"
  volume_type            = "gp3"
  encrypted              = true
  file_system_type       = "ext4"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  is_default_class       = false

  labels = {
    project     = "uptime-kuma"
    environment = "dev"
    managed-by  = "terraform"
  }
}
```

## Application Configuration

An application must request the StorageClass by name.

Example Helm values:

```yaml
persistence:
  enabled: true
  storageClass: gp3
  size: 5Gi
```

This does not create the StorageClass. It requests an existing StorageClass named `gp3`.

Terraform must create the StorageClass before Helm installs the application.

## Inputs

| Name                     | Type          | Default                  | Description                                      |
| ------------------------ | ------------- | ------------------------ | ------------------------------------------------ |
| `name`                   | `string`      | `"gp3"`                  | Name of the Kubernetes StorageClass              |
| `storage_provisioner`    | `string`      | `"ebs.csi.aws.com"`      | CSI provisioner used for dynamic volumes         |
| `volume_type`            | `string`      | `"gp3"`                  | Amazon EBS volume type                           |
| `encrypted`              | `bool`        | `true`                   | Enable EBS volume encryption                     |
| `file_system_type`       | `string`      | `"ext4"`                 | Filesystem created on the volume                 |
| `reclaim_policy`         | `string`      | `"Retain"`               | Behavior after the PVC is deleted                |
| `volume_binding_mode`    | `string`      | `"WaitForFirstConsumer"` | When provisioning and binding occur              |
| `allow_volume_expansion` | `bool`        | `true`                   | Allow existing PVCs to be expanded               |
| `is_default_class`       | `bool`        | `false`                  | Mark this as the cluster default StorageClass    |
| `labels`                 | `map(string)` | `{}`                     | Labels added to the StorageClass                 |
| `annotations`            | `map(string)` | `{}`                     | Additional annotations added to the StorageClass |

## Outputs

| Name                     | Description                              |
| ------------------------ | ---------------------------------------- |
| `name`                   | Name of the created StorageClass         |
| `storage_provisioner`    | CSI provisioner used by the StorageClass |
| `reclaim_policy`         | Configured reclaim policy                |
| `volume_binding_mode`    | Configured volume binding mode           |
| `allow_volume_expansion` | Whether PVC expansion is enabled         |

## Development Cleanup Behavior

The development environment uses:

```hcl
reclaim_policy = "Delete"
```

The Uptime Kuma StatefulSet also uses:

```yaml
persistentVolumeClaimRetentionPolicy:
  whenDeleted: Delete
  whenScaled: Retain
```

The expected cleanup flow is:

```text
Helm release deleted
        ↓
StatefulSet deleted
        ↓
PVC deleted by StatefulSet retention policy
        ↓
PV deleted because reclaimPolicy is Delete
        ↓
EBS volume deleted by the AWS EBS CSI Driver
```

The Helm release must be removed while the EKS cluster and EBS CSI Driver are still available.

Recommended destruction order:

```text
1. Uninstall the Helm release
2. Verify that PVCs and PVs were deleted
3. Destroy the cluster configuration Terraform state
4. Destroy the AWS infrastructure Terraform state
```

## Production Considerations

For production environments, consider using:

```hcl
reclaim_policy = "Retain"
```

A `Retain` policy protects storage from automatic deletion after a PVC is removed.

The correct value depends on the environment:

* Disposable development environment: `Delete`
* Persistent production environment: usually `Retain`

## Security

The module:

* Enables EBS encryption by default
* Does not store AWS credentials
* Does not store Kubernetes credentials
* Does not store passwords or tokens
* Does not contain encryption key material

The Kubernetes provider authenticates to EKS outside this module.

## Prerequisites

Before applying the module:

* The EKS cluster must exist
* The AWS EBS CSI Driver must be installed and operational
* The Terraform caller must be authorized to access the Kubernetes API
* The Kubernetes provider must be configured

## Validation

After applying the module:

```bash
kubectl get storageclass gp3
```

Expected configuration:

```text
NAME   PROVISIONER       RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION
gp3    ebs.csi.aws.com   Delete          WaitForFirstConsumer   true
```

Inspect the full resource:

```bash
kubectl describe storageclass gp3
```

## Cost

The StorageClass itself does not create a billable EBS volume.

EBS charges begin only after an application creates a PVC and the EBS CSI Driver dynamically provisions an EBS volume.
