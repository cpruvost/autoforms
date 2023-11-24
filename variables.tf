### These information are needed only outside of OCI Terraform Stack Manager
variable "tenancy_ocid" {
    description = "The OCI Tenancy ocid"
    type        = string
}

variable "user_ocid" {
    description = "The OCI User ocid"
    type        = string
}

variable "fingerprint" {
    description = "The Fingerprint of the OCI API Key"
    type        = string
}

variable "private_key_path" {
    description = "The Path of the OCI API Key"
    type        = string
}

variable "ssh_public_key" {
    description = "the SSH Public Key To access DB VM"
    type        = string
}

variable "ssh_private_key" {
     description = "the SSH Private Key To access DB VM"
    type        = string
}

variable "region" {
    description = "The OCI region"
    type        = string
}

variable "compartment_ocid" {
    description = "The OCI Compartment ocid"
    type        = string
}

# variable "private_subnet_ocid" {
#     description = "The OCI Private Subnet ocid"
#     type        = string
# }

# variable "public_subnet_ocid" {
#     description = "The OCI Public Subnet ocid"
#     type        = string
# }

# Use data to get ADs is better.
# variable "availability_domain" {
#     description = "The OCI Availability Domain"
#     type        = string
# }