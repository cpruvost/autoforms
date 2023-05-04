output "vcn_id" {
  value =  module.network.vcn_id
}

output "private_subnet_id" {
  value =  module.network.private_subnet_id
}

output "public_subnet_id" {
  value =  module.network.public_subnet_id
}

output "db_url" {
  value = module.dbsystem.db_url
}  

output "forms_ip_address" {
  value = module.forms.forms_ip_address
}

output "public_ip_lb" {
  value = module.loadbalancer.public_ip_lb
}