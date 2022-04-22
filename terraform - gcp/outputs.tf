output "instance_self_links" {
  description = "List of self-links for compute instance"
  value       = google_compute_instance.compute_instance.*.self_link
}

output "instance_ip" {
  description = "List of IPs for compute instance"
  value       = google_compute_instance.compute_instance.*.network_interface.0.access_config.0.nat_ip
}