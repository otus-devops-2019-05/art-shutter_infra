resource "google_compute_instance_group" "redditapps" {
  name        = "redditapps"
  description = "Instance goup for rediitapp load balancer"

  instances = [
    "${google_compute_instance.app.self_link}",
    "${google_compute_instance.app2.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_backend_service" "app-balancer-backend" {
  name      = "redditapp-balancer"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = "${google_compute_instance_group.redditapps.self_link}"
  }

  health_checks = [
    "${google_compute_http_health_check.health.self_link}",
  ]
}

resource "google_compute_http_health_check" "health" {
  name         = "health"
  request_path = "/"
  port = "9292"
}
