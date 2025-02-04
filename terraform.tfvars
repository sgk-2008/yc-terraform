name       = "terraform"
user_name  = "user"
user_pass  = ""
admin_pass = ""
ssh_key_path = "" # Указывается имя ssh ключа, если он лежит в этой же папке или путь к нему

platform_id = "standard-v3" # Стандартные платформы: standard-v3 (Intel Ice Lake), standard-v2 (Intel Cascade Lake), standard-v1 (Intel Broadwell)

preemptible = "true" # Непрерываемая машина - false, Прерываемая - true

vm_config = {
  "web"  = { cores = 2, memory = 2, core_fraction = 50, disk_size = 20, disk_type = "network-ssd" }
  "db"   = { cores = 2, memory = 2, core_fraction = 20, disk_size = 20, disk_type = "network-hdd" }
  "cashe"   = { cores = 2, memory = 2, core_fraction = 20, disk_size = 20, disk_type = "network-hdd" }
  # Можно выбрать: network-hdd — стандартный сетевой HDD, network-ssd — сетевой SSD (лучший баланс цена/производительность), network-ssd-nonreplicated — сетевой SSD без репликации (дешевле, но без отказоустойчивости), local-ssd — локальный SSD (самая высокая производительность, но данные не сохраняются при удалении ВМ)
}