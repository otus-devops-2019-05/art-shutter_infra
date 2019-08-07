variable source_ranges {
  description = "Allowed IP addresses"

  default = ["0.0.0.0/0"]
}

variable "port_app" {
  description = "Allowed app ports"

  default = ["80"]
}

