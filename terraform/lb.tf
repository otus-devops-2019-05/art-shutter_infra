resource "google_compute_instance_group" "redditapps" {
  name        = "redditapps"
  description = "Instance goup for redditapp load balancer"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_global_address" "lb-ip" {
  name = "lb-ip"
}

resource "google_compute_target_tcp_proxy" "reddit-proxy" {
  name            = "reddit-proxy"
  backend_service = "${google_compute_backend_service.app-balancer-backend.self_link}"
}

resource "google_compute_global_forwarding_rule" "lb-forward-rule" {
  name       = "lb-forward-rule"
  port_range = "443"
  ip_address = "${google_compute_global_address.lb-ip.address}"
  target     = "${google_compute_target_tcp_proxy.reddit-proxy.self_link}"
}

resource "google_compute_backend_service" "app-balancer-backend" {
  name             = "app-balancer-backend"
  protocol         = "TCP"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
    group = "${google_compute_instance_group.redditapps.self_link}"
  }

  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]
}

resource "google_compute_health_check" "healthcheck" {
  name               = "healthcheck"
  check_interval_sec = 5
  timeout_sec        = 5

  tcp_health_check {
    port = "9292"
  }
}
