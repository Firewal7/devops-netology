# Service account for bucket
resource "yandex_iam_service_account" "bucket-sa" {
  name        = "bucket-sa"
  description = "service account for bucket"
}

# Role for service account
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

# Keys for service account
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "static access key for object storage"
}

# Create bucket
resource "yandex_storage_bucket" "vp-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "sofin-netology-bucket-2023"

  max_size = 1073741824 # 1 Gb

  anonymous_access_flags {
    read = true
    list = false
  }
}

# Add picture in the bucket
resource "yandex_storage_object" "my-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.vp-bucket.id
  key        = "image.png"
  source     = var.yc_image
}

# Network
resource "yandex_vpc_network" "netology-net" {
  name = "netology-net"
}

# Public network
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yc_region
  network_id     = yandex_vpc_network.netology-net.id
}

# Service account for VM group
resource "yandex_iam_service_account" "sof-ra" {
  name        = "sof-ra"
  description = "Service account for managing VM group"
}

# Add role editor for service account
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sof-ra.id}"
}

# VM group
resource "yandex_compute_instance_group" "vp-nlb-ig" {
  name               = "vp-nlb-ig"
  folder_id          = var.yc_folder_id
  service_account_id = "${yandex_iam_service_account.sof-ra.id}"
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" # LAMP image
     }
    }

    network_interface {
      network_id = "${yandex_vpc_network.netology-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }

    metadata = {
      ssh-keys  = "ubuntu:${file("/root/.ssh/id.rsa.pub")}"
      user-data = "#!/bin/bash\n cd /var/www/html\n echo \"<html><head><meta charset=\"utf-8\"><title>ДЗ YC-Bucket</title></head><h2>Домашнее задание: &#171;Вычислительные мощности. Балансировщики нагрузки&#187;</h2><img src='https://${yandex_storage_bucket.vp-bucket.bucket_domain_name}/${yandex_storage_object.my-picture.key}'></html>\" > index.html"
    }
    labels = {
      group = "network-load-balanced"
     }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_region]
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }

  health_check {
    interval = 2
    timeout = 1
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }

  load_balancer {
    target_group_name        = "vp-target-nlb-group"
    target_group_description = "Target group for network balancer"
  }
}

# Network load balancer
resource "yandex_lb_network_load_balancer" "vp-nlb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.vp-nlb-ig.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 5
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# Result
output "pic-url" {
  value = "https://${yandex_storage_bucket.vp-bucket.bucket_domain_name}/${yandex_storage_object.my-picture.key}"
  description = "Bucket picture address"
}

output "nlb-address" {
  value = yandex_lb_network_load_balancer.vp-nlb-1.listener.*.external_address_spec[0].*.address
  description = "Network LB address"
}
