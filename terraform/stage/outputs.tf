output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

#output "app_external_ip_lb" {
#  value = "${google_compute_forwarding_rule.reddit-app-lb.ip_address}"
#}

output "db_external_ip" {
  value = "${module.db.db-address}"
}
