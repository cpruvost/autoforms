variable "tenancy_ocid" {
    description = "The OCI Tenancy ocid"
    type        = string
}

variable "compartment_ocid" {
    description = "The OCI Compartment ocid"
    type        = string
}

#variable "kms_key_id" {
#}
#
#variable "kms_key_version_id" {
#}
#
#variable "vault_id" {
#}

variable "ssh_public_key" {
    description = "the SSH Public Key To access DB VM"
    type        = string
}

variable "ssh_private_key" {
     description = "the SSH Private Key To access DB VM"
    type        = string
}

variable "subnet_id" {
    description = "the Subnet Id where we will create the DB"
    type        = string
}

# DBSystem specific
variable "db_system_shape" {
  default = "VM.Standard.E4.Flex"
}

variable "cpu_core_count" {
  default = "2"
}

variable "db_system_storage_volume_performance_mode" {
  default = "BALANCED"
}

variable "db_edition" {
  default = "ENTERPRISE_EDITION"
}

variable "db_admin_password" {
  default = "BEstrO0ng_#12"
}

variable "db_version" {
  default = "19.0.0.0"
}

variable "db_disk_redundancy" {
  default = "NORMAL"
}

variable "sparse_diskgroup" {
  default = true
}

variable "hostname" {
  default = "myoracledb"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "AL32UTF8"
}

variable "db_workload" {
  default = "OLTP"
}

variable "pdb_name" {
  default = "pdbName"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "node_count" {
  default = "1"
}

# variable "test_database_software_image_ocid" {
# }


# variable "network_security_group_id" {
# }

# variable "network_security_group_backup_id" {
# }

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

# # Get DB node list
# data "oci_database_db_nodes" "db_nodes" {
#   compartment_id = var.compartment_ocid
#   db_system_id   = oci_database_db_system.test_db_system.id
# }

# # Get DB node details
# data "oci_database_db_node" "db_node_details" {
#   db_node_id = data.oci_database_db_nodes.db_nodes.db_nodes[0]["id"]
# }

# Gets the OCID of the first (default) vNIC
#data "oci_core_vnic" "db_node_vnic" {
#    vnic_id = data.oci_database_db_node.db_node_details.vnic_id
#}

data "oci_database_db_homes" "db_homes" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.test_db_system.id
}

data "oci_database_databases" "databases" {
  compartment_id = var.compartment_ocid
  db_home_id     = data.oci_database_db_homes.db_homes.db_homes[0].db_home_id
}

data "oci_database_pluggable_databases" "test_pluggable_databases" {

    #Optional
    #compartment_id = var.compartment_ocid
    database_id = data.oci_database_databases.databases.databases[0].id
    #pdb_name = var.pluggable_database_pdb_name
    #state = var.pluggable_database_state
}

# data "oci_database_db_versions" "test_db_versions_by_db_system_id" {
#   compartment_id = var.compartment_ocid
#   db_system_id   = oci_database_db_system.test_db_system.id
# }

# resource "oci_database_backup" "test_backup" {
#   database_id = "${data.oci_database_databases.databases.databases.0.id}"
#   display_name = "Monthly Backup"
# }

data "oci_database_db_system_shapes" "test_db_system_shapes" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid

  filter {
    name   = "shape"
    values = [var.db_system_shape]
  }
}

# data "oci_database_db_systems" "db_systems" {
#   compartment_id = var.compartment_ocid

#   filter {
#     name   = "id"
#     values = [oci_database_db_system.test_db_system.id]
#   }
# }

resource "oci_database_db_system" "test_db_system" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  database_edition    = var.db_edition

  db_home {
    database {
      admin_password = var.db_admin_password
#      kms_key_version_id    = var.kms_key_version_id
#      kms_key_id     = var.kms_key_id
#      vault_id       = var.vault_id
      db_name        = "aTFdbVm"
      character_set  = var.character_set
      ncharacter_set = var.n_character_set
      db_workload    = var.db_workload
      pdb_name       = var.pdb_name

      db_backup_config {
        auto_backup_enabled = false
      }
    }

    db_version   = "19.18.0.0"
    display_name = "MyTFDBHomeVm"
  }

  db_system_options {
    storage_management = "LVM"
  }

  disk_redundancy         = var.db_disk_redundancy
  shape                   = var.db_system_shape
  cpu_core_count          = var.cpu_core_count
  storage_volume_performance_mode = var.db_system_storage_volume_performance_mode
  subnet_id               = var.subnet_id
  ssh_public_keys         = [var.ssh_public_key]
  display_name            = "MyTFDBSystemVM"
  hostname                = var.hostname
  data_storage_size_in_gb = var.data_storage_size_in_gb
  license_model           = var.license_model
  node_count              = data.oci_database_db_system_shapes.test_db_system_shapes.db_system_shapes[0]["minimum_node_count"]
  #nsg_ids                 = [var.network_security_group_backup_id, var.network_security_group_id]

  #To use defined_tags, set the values below to an existing tag namespace, refer to the identity example on how to create tag namespaces
  #defined_tags  = {"${oci_identity_tag_namespace.tag-namespace1.name}.${oci_identity_tag.tag1.name}" = "value"}

  # freeform_tags = {
  #   "Department" = "Finance"
  # }
}

# resource "oci_database_db_system" "db_system_bkup" {
#   source = "DB_BACKUP"
#   availability_domain = data.oci_identity_availability_domain.ad.name
#   compartment_id = var.compartment_ocid
#   subnet_id = var.subnet_id
#   database_edition = var.db_edition
#   disk_redundancy = var.db_disk_redundancy
#   shape = var.db_system_shape
#   cpu_core_count= var.cpu_core_count
#   storage_volume_performance_mode= var.db_system_storage_volume_performance_mode
#   ssh_public_keys         = [var.ssh_public_key]
#   hostname = var.hostname
#   data_storage_size_in_gb = var.data_storage_size_in_gb
#   license_model = var.license_model
#   node_count = data.oci_database_db_system_shapes.test_db_system_shapes.db_system_shapes[0]["minimum_node_count"]
#   display_name = "tfDbSystemFromBackupWithCustImg"

#   db_home {
#     db_version = "19.15.0.0"
# #    database_software_image_id = var.test_database_software_image_ocid
#     database {
#       admin_password = "BEstrO0ng_#11"
#       backup_tde_password = "BEstrO0ng_#11"
#       backup_id = "${oci_database_backup.test_backup.id}"
#       db_name = "dbback"
#     }
#   }
# }