terraform {
  required_version = ">=0.11"
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "ssh-keys" {
  metadata {
    ssh-keys = <<EOF
appuser:${file(var.public_key_path)}
appuser1:${file(var.public_key_path)}
EOF
  }
}

module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"

  zone = "${var.zone}"

  app_disk_image = "${var.app_disk_image}"
}

module "db" {
  source = "../modules/db"

  public_key_path = "${var.public_key_path}"

  zone = "${var.zone}"

  db_disk_image = "${var.db_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = "${var.source_ranges_stage}"
}

############################################################################
/*

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("~/.ssh/appuser")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
*/


/* resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-delfault"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["redditapp"]
}
*/

