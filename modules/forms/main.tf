variable "compartment_ocid" {
    description = "The OCI Compartment ocid"
    type        = string
}

variable "tenancy_ocid" {
    description = "The OCI Tenancy ocid"
    type        = string
}

variable "subnet_id" {
    description = "the Subnet Id where we will create the Forms VM"
    type        = string
}

variable "ssh_public_key" {
    description = "the SSH Public Key To access DB VM"
    type        = string
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "generated_oci_core_instance" {
	agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Oracle Java Management Service"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "OS Management Service Agent"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Management Agent"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Custom Logs Monitoring"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Run Command"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Block Volume Management"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Bastion"
		}
	}
	availability_config {
		recovery_action = "RESTORE_INSTANCE"
	}
	availability_domain = data.oci_identity_availability_domain.ad.name
	compartment_id = var.compartment_ocid
	create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "false"
		subnet_id = var.subnet_id
	}
	display_name = "instance-Forms-UC"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	metadata = {
		"ssh_authorized_keys" = var.ssh_public_key
	}
	shape = "VM.Standard.E4.Flex"
	shape_config {
		baseline_ocpu_utilization = "BASELINE_1_1"
		memory_in_gbs = "32"
		ocpus = "2"
	}
	source_details {
		source_id = "ocid1.image.oc1..aaaaaaaa5rcfxi6dy5xnlvp5gstu45ba66tgyptbn2cqg7j3kjou2c5fls5q"
		source_type = "image"
	}
	depends_on = [
		oci_core_app_catalog_subscription.generated_oci_core_app_catalog_subscription
	]
}

resource "oci_core_app_catalog_subscription" "generated_oci_core_app_catalog_subscription" {
	compartment_id = var.compartment_ocid
	eula_link = "${oci_core_app_catalog_listing_resource_version_agreement.generated_oci_core_app_catalog_listing_resource_version_agreement.eula_link}"
	listing_id = "${oci_core_app_catalog_listing_resource_version_agreement.generated_oci_core_app_catalog_listing_resource_version_agreement.listing_id}"
	listing_resource_version = "12.2.1.19_230317"
	oracle_terms_of_use_link = "${oci_core_app_catalog_listing_resource_version_agreement.generated_oci_core_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link}"
	signature = "${oci_core_app_catalog_listing_resource_version_agreement.generated_oci_core_app_catalog_listing_resource_version_agreement.signature}"
	time_retrieved = "${oci_core_app_catalog_listing_resource_version_agreement.generated_oci_core_app_catalog_listing_resource_version_agreement.time_retrieved}"
}

resource "oci_core_app_catalog_listing_resource_version_agreement" "generated_oci_core_app_catalog_listing_resource_version_agreement" {
	listing_id = "ocid1.appcataloglisting.oc1..aaaaaaaaui7smknjjwxcjrroz4r63px66rwjohoi5hsngzv2rxzfueztk3mq"
	listing_resource_version = "12.2.1.19_230317"
}