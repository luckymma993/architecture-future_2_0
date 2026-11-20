terraform {
  required_version = ">= 1.5.0"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_file
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_vpc_network" "net" {
  name = "future20-net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "future20-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_cidr]
}

# Доступ: SSH для администрирования и HTTPS для портала витрины
resource "yandex_vpc_security_group" "sg" {
  name        = "future20-sg"
  network_id  = yandex_vpc_network.net.id
  description = "SSH for admins, HTTPS for portal"

  ingress {
    protocol    = "TCP"
    port        = 22
    v4_cidr_blocks = var.admin_cidrs
  }
  ingress {
    protocol    = "TCP"
    port        = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Загрузочные диски стендов: network-hdd.
# Под нагрузку целевой архитектуры растёт размер, тип диска тот же
# (см. justification.md, раздел о выборе дисков).
resource "yandex_compute_disk" "boot" {
  for_each = var.vms

  name     = "${each.key}-boot"
  type     = var.disk_type
  zone     = var.zone
  size     = each.value.disk_size
  image_id = data.yandex_compute_image.ubuntu.image_id
}

# Виртуальные машины доменных стендов
resource "yandex_compute_instance" "vm" {
  for_each = var.vms

  name     = each.key
  zone     = var.zone
  platform_id = "standard-v3"

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot[each.key].id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    security_group_ids = [yandex_vpc_security_group.sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
