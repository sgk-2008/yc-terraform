# Зона, в которой будут развернуты ВМ
variable "zone" {
  type    = string
  default = "ru-central1-d" 
}

variable "network" {
  type    = string
  default = "subnet1"
}

# Имя виртуальной сети
variable "subnet" {
  type    = string
  default = "subnet1" # Имя подсети
}

# Диапазон IP-адресов для подсети
variable "subnet_v4_cidr_blocks" {
  type    = list(string)
  default = ["192.168.0.0/16"] 
}

# Разрешить NAT для выхода в интернет
variable "nat" {
  type    = bool
  default = true 
}

# Семейство образов ОС для ВМ
variable "image_family" {
  type    = string
  default = "ubuntu-2404-lts-oslogin" 
}

variable "vm_config" {
  type = map(object({
    cores         = number # Количество ядер CPU
    memory        = number # Объем оперативной памяти в ГБ
    core_fraction = number # Гарантированная доля процессорного времени
    disk_size     = number # Размер диска в ГБ
    disk_type     = string # Тип диска: network-hdd, network-ssd, network-ssd-nonreplicated, local-ssd
  }))
  description = "Параметры для разных типов ВМ"
  default = {
    terraform-1   = { cores = 2, memory = 4, core_fraction = 20, disk_size = 20, disk_type = "network-ssd" }
    terraform-2   = { cores = 2, memory = 4, core_fraction = 20, disk_size = 20, disk_type = "network-hdd" }
  }
}

# Имя ресурса (если требуется)
variable "name" {
  type = string 
}

# Тип платформы
variable "platform_id" {
  type    = string
  default = "standard-v3" # также, доступны standard-v3, intel-broadwell-burst, intel-icelake-burst
}

# Прерываемость ВМ
variable "preemptible" {
  type        = bool	
  description = "Разрешить создание прерываемой ВМ"
  default     = true
}

# Имя пользователя для входа
variable "user_name" {
  default = ""
  type    = string 
}

# Пароль пользователя (если используется)
variable "user_pass" {
  default = ""
  type    = string 
}

# Пароль администратора (если используется)
variable "admin_pass" {
  default = ""
  type    = string 
}

variable "timeout_create" {
  default = "10m" # Таймаут создания ВМ
}

variable "timeout_delete" {
  default = "10m" # Таймаут удаления ВМ
}

variable "ssh_key_path" {
  type        = string
  description = "Путь к SSH-ключу для подключения"
}
