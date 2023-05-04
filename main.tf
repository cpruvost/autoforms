terraform {
  required_providers {
    oci = {
      version = "~> 4.112.0"
    }
  }

  #OCI Terraform Stack does not support last version
  required_version = "~> 1.3.6"
  #required_version = "~> 1.2.9"
}

module "network" {
  source  = "./modules/network"

  compartment_ocid  = var.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
}

module "dbsystem" {
  source  = "./modules/dbsystem"

  compartment_ocid  = var.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_id = module.network.private_subnet_id
  ssh_private_key = var.ssh_private_key
  ssh_public_key = var.ssh_public_key
  #network_security_group_backup_id = module.network.network_security_group_backup_id
  #network_security_group_id = module.network.network_security_group_id
}

module "forms" {
  source  = "./modules/forms"

  compartment_ocid  = var.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  subnet_id = module.network.private_subnet_id
  #ssh_private_key = var.ssh_private_key
  ssh_public_key = var.ssh_public_key
  #network_security_group_backup_id = module.network.network_security_group_backup_id
  #network_security_group_id = module.network.network_security_group_id
}

module "loadbalancer" {
  source  = "./modules/loadbalancer"

  compartment_ocid  = var.compartment_ocid
  subnet_id = module.network.public_subnet_id
  private_ips = [module.forms.forms_ip_address]
}