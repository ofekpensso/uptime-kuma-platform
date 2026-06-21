variable "name" {
  description = "Name of the Kubernetes StorageClass."
  type        = string
  default     = "gp3"
}

variable "storage_provisioner" {
  description = "CSI provisioner used to dynamically create persistent volumes."
  type        = string
  default     = "ebs.csi.aws.com"
}

variable "volume_type" {
  description = "Amazon EBS volume type."
  type        = string
  default     = "gp3"
}

variable "encrypted" {
  description = "Whether dynamically provisioned EBS volumes are encrypted."
  type        = bool
  default     = true
}

variable "file_system_type" {
  description = "Filesystem used for dynamically provisioned volumes."
  type        = string
  default     = "ext4"
}

variable "reclaim_policy" {
  description = "What happens to the persistent volume after its PVC is deleted."
  type        = string
  default     = "Retain"

  validation {
    condition     = contains(["Delete", "Retain"], var.reclaim_policy)
    error_message = "reclaim_policy must be Delete or Retain."
  }
}

variable "volume_binding_mode" {
  description = "Controls when volume provisioning and binding occur."
  type        = string
  default     = "WaitForFirstConsumer"

  validation {
    condition = contains(
      ["Immediate", "WaitForFirstConsumer"],
      var.volume_binding_mode
    )

    error_message = "volume_binding_mode must be Immediate or WaitForFirstConsumer."
  }
}

variable "allow_volume_expansion" {
  description = "Whether PVCs using this StorageClass may be expanded."
  type        = bool
  default     = true
}

variable "is_default_class" {
  description = "Whether this StorageClass is the cluster default."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to the StorageClass."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Additional annotations applied to the StorageClass."
  type        = map(string)
  default     = {}
}