# Публичная сеть и ВМ
resource "yandex_vpc_network" "netology-network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology-network.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "public-ubuntu" {
  image_id = var.public_image
}

resource "yandex_compute_instance" "public-instance" {
  name        = "${local.public}"
  hostname    = "${local.public}"
  platform_id = "standard-v1"
  resources {
    cores         = var.public_resources.cores
    memory        = var.public_resources.memory
    core_fraction = var.public_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.public-ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/root/.ssh/id.rsa.pub")}"
  }
}

# ВМ для NAT
data "yandex_compute_image" "nat-ubuntu" {
  image_id = var.nat_image
}

resource "yandex_compute_instance" "nat-instance" {
  name        = "${local.nat}"
  hostname    = "${local.nat}"
  platform_id = "standard-v1"
  resources {
    cores         = var.nat_resources.cores
    memory        = var.nat_resources.memory
    core_fraction = var.nat_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/root/.ssh/id.rsa.pub")}"
  }
}

resource "yandex_vpc_route_table" "private-netology" {
  name       = "private-netology"
  network_id = yandex_vpc_network.netology-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private-netology.id
}

data "yandex_compute_image" "private-ubuntu" {
  image_id = var.private_image
}

resource "yandex_compute_instance" "private-instance" {
  name        = "${local.private}"
  hostname    = "${local.private}"
  platform_id = "standard-v1"
  resources {
    cores         = var.private_resources.cores
    memory        = var.private_resources.memory
    core_fraction = var.private_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.private-ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/root/.ssh/id.rsa.pub")}"
  }
}
