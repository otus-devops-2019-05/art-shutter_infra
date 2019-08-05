resource "google_compute_firewall" "firewall_ssh" {
  name    = "default-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.source_ranges}"
}

resource "google_compute_firewall" "firewall_http" {
  name = "default-allow-app-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "${var.port_app}",
    ]
  }
  
}

