output "internal_ips" {
  description = "Внутренние адреса виртуальных машин"
  value       = { for k, vm in yandex_compute_instance.vm : k => vm.network_interface[0].ip_address }
}

output "nat_ips" {
  description = "Публичные адреса виртуальных машин"
  value       = { for k, vm in yandex_compute_instance.vm : k => vm.network_interface[0].nat_ip_address }
}

output "subnet_id" {
  description = "Идентификатор подсети для добавления новых стендов"
  value       = yandex_vpc_subnet.subnet.id
}
