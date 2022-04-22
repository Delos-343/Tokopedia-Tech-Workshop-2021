# Input variable definitions

variable "ci_name" {
  description = "Name for instances."
}

variable "ci_machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "ci_tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
}

variable "ci_labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "ci_metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

variable "ci_metadata_startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "ci_boot_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}

variable "ci_boot_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "ci_boot_image_project" {
  description = "Project where the source image comes from. The default project contains images that support Shielded VMs if desired"
  default     = ""
}

variable "ci_boot_disk_size" {
  description = "Boot disk size in GB"
  default     = 20
  type        = number
}

variable "ci_boot_disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "ci_boot_disk_auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = true
  type        = bool
}

variable "ci_attached_disks" {
  description = "Additional disks, if options is null defaults will be used in its place."
  type = list(object({
    name        = string
    size        = number
    auto_delete = bool
    mode        = string
    type        = string
  }))
  default = []
}

variable "ci_firewall_allow_ports" {
  description = "Firewall rules will be applied to the instance."
  type = list(object({
    name     = string
    protocol = string
    ports    = list(string)
  }))
  default = []
}