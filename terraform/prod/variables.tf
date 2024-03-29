variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "us-central1"
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

variable "count" {
  description = "number of instances"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable source_ranges_prod {
  description = "Source ranges for firewall, production"
  default     = ["0.0.0.0/0"]
}
