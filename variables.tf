terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Определение провайдера Yandex Cloud
provider "yandex" {
  zone = var.zone
}

# Создание сети VPC
resource "yandex_vpc_network" "default" {
  name = var.network
}

# Создание подсети VPC
resource "yandex_vpc_subnet" "default" {
  network_id     = yandex_vpc_network.default.id
  name           = var.subnet
  v4_cidr_blocks = var.subnet_v4_cidr_blocks
  zone           = var.zone
}

# Получение образа операционной системы
data "yandex_compute_image" "default" {
  family = var.image_family
}

# Шаблон инициализации ВМ
data "template_file" "default" {
  template = file("${path.module}/init.ps1")
  vars = {
    user_name  = var.user_name
    user_pass  = var.user_pass
    admin_pass = var.admin_pass
  }
}

# Создание виртуальных машин
resource "yandex_compute_instance" "default" {
  for_each    = var.vm_config  # Создание нескольких ВМ с разными конфигурациями
  name        = each.key
  hostname    = each.key
  zone        = var.zone
  platform_id = var.platform_id # Задаём платформу процессора

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction # Гарантированная доля CPU
  }

  scheduling_policy {
    preemptible = var.preemptible # Прерываемость машины (экономия на стоимости)
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.default.id
      size     = each.value.disk_size # Размер диска для каждой ВМ
      type     = each.value.disk_type # Тип диска (HDD, SSD и т. д.)
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.user_name}:${file(var.ssh_key_path)}"
  }

  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
  }
}

# Вывод списка созданных машин
output "names" {
  value = [for vm in yandex_compute_instance.default : vm.name]
}

# Вывод списка публичных IP-адресов машин
output "addresses" {
  value = [for vm in yandex_compute_instance.default : vm.network_interface.0.nat_ip_address]
}
