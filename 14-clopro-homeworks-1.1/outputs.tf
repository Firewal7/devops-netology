output "vm_external_ip_address_public" {
value = yandex_compute_instance.public-instance.network_interface.0.ip_address
}

output "vm_external_ip_address_nat" {
value = yandex_compute_instance.nat-instance.network_interface.0.ip_address
}

output "vm_external_ip_address_private" {
value = yandex_compute_instance.private-instance.network_interface.0.ip_address
}