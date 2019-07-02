variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
}

variable "zone" {
  description = "Project zone"
  default     = "us-central1-a"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}
