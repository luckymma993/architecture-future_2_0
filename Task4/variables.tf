variable "sa_key_file" {
  description = "Путь к файлу авторизованного ключа сервисного аккаунта"
  type        = string
}

variable "yc_cloud_id" {
  description = "Идентификатор облака"
  type        = string
}

variable "yc_folder_id" {
  description = "Идентификатор каталога"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "image_family" {
  description = "Семейство образов ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "subnet_cidr" {
  description = "Адреса подсети доменных стендов"
  type        = string
  default     = "10.10.10.0/24"
}

variable "disk_type" {
  description = "Тип загрузочных дисков: network-ssd или network-hdd"
  type        = string
  default     = "network-hdd"
}

variable "admin_cidrs" {
  description = "Адреса администраторов с доступом по SSH"
  type        = list(string)
  default     = ["203.0.113.10/32"]
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH-ключу"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vms" {
  description = "Параметры виртуальных машин стендов"
  type = map(object({
    cores     = number
    memory    = number
    disk_size = number
  }))
  default = {
    lakehouse-stand = {
      cores     = 2
      memory    = 4
      disk_size = 10
    }
    portal-stand = {
      cores     = 2
      memory    = 4
      disk_size = 10
    }
  }
}
