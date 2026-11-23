sa_key_file = "authorized-key.json"
yc_cloud_id = "b1gevdnf1gsdg0rvde2h"
yc_folder_id = "b1ge543b28c4tvmclt4f"

zone        = "ru-central1-a"
image_family = "ubuntu-2204-lts"
subnet_cidr = "10.10.10.0/24"
disk_type   = "network-hdd"

admin_cidrs = ["203.0.113.10/32"]

ssh_public_key_path = "~/.ssh/id_ed25519.pub"

vms = {
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
