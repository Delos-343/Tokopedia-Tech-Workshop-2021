
# # Data Sources

data "google_compute_network" "network" {
  name = "vpc-workshop-default"
}

data "google_compute_subnetwork" "subnetwork" {
  name = "subnet-a"
}

data "google_compute_image" "image" {
  project = var.ci_boot_image != "" ? var.ci_boot_image_project : "ubuntu-os-cloud"
  name    = var.ci_boot_image != "" ? var.ci_boot_image : "ubuntu-2004-focal-v20210908"
}

data "google_compute_image" "image_family" {
  project = var.ci_boot_image_family != "" ? var.ci_boot_image_project : "ubuntu-os-cloud"
  family  = var.ci_boot_image_family != "" ? var.ci_boot_image_family : "ubuntu-2004-lts"
}


# # Firewall

resource "google_compute_firewall" "firewall" {
  for_each = {
    for i in var.ci_firewall_allow_ports : i.name => i
  }

  name    = "fw-allow-${var.ci_name}-${each.key}"
  network = data.google_compute_network.network.name
  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.ci_tags
}


# # Disk

resource "google_compute_disk" "disks" {
  for_each = {
    for i in var.ci_attached_disks : i.name => i
  }

  name   = format("%s-%s", var.ci_name, replace(each.key, "/", "--"))
  type   = each.value.type
  size   = each.value.size
  labels = var.ci_labels
}


# # Compute Instance

resource "google_compute_instance" "compute_instance" {
  name                    = var.ci_name
  machine_type            = var.ci_machine_type
  tags                    = var.ci_tags
  labels                  = var.ci_labels
  metadata                = var.ci_metadata
  metadata_startup_script = var.ci_metadata_startup_script

  boot_disk {
    initialize_params {
      type  = var.ci_boot_disk_type
      image = var.ci_boot_image != "" ? data.google_compute_image.image.self_link : data.google_compute_image.image_family.self_link
      size  = var.ci_boot_disk_size
    }
    auto_delete = var.ci_boot_disk_auto_delete
  }

  dynamic "attached_disk" {
    for_each = var.ci_attached_disks
    iterator = config
    content {
      device_name = replace(config.value.name, "/", "--")
      mode        = config.value.mode
      source      = google_compute_disk.disks[config.value.name].name
    }
  }

  network_interface {
    network    = data.google_compute_network.network.name
    subnetwork = data.google_compute_subnetwork.subnetwork.name
    access_config {
    }
  }
}