output "vcn_id" {
  value =  oci_core_vcn.export_DemoVCN.id
}

output "private_subnet_id" {
  value =  oci_core_subnet.export_private-subnet-DemoVCN.id
}

output "public_subnet_id" {
  value =  oci_core_subnet.export_public-subnet-DemoVCN.id
}

# output "network_security_group_id" {
#     value = oci_core_network_security_group.test_network_security_group.id
# }

# output "network_security_group_backup_id" {
#     value = oci_core_network_security_group.test_network_security_group_backup.id
# }

