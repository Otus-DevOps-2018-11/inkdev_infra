resource "google_compute_forwarding_rule" "reddit-app-lb" {
  name                  = "reddit-app-lb"
  project               = "${var.project}"
  region                = "${var.region}"
  port_range            = "9292"
  target                = "${google_compute_target_pool.reddit-pool.self_link}"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_pool" "reddit-pool" {
  name = "reddit-pool"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.reddit-health.name}",
  ]
}

resource "google_compute_http_health_check" "reddit-health" {
  name               = "reddit-health"
  port               = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
  request_path       = "/"
}
