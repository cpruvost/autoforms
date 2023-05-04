### VCN variables
variable "tenancy_ocid" {
    description = "The OCI Tenancy ocid"
    type        = string
}

variable "compartment_ocid" {
    description = "The OCI Compartment ocid"
    type        = string
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_services" "test_services" {
}

### VCN Resources
resource oci_core_vcn export_DemoVCN {
  cidr_blocks = [
    "10.0.0.0/16",
  ]
  compartment_id = var.compartment_ocid
 
  display_name = "DemoVCN"
  dns_label    = "demovcn"
}

resource oci_core_subnet export_public-subnet-DemoVCN {
  #availability_domain = <<Optional value not found in discovery>>
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_default_dhcp_options.export_Default-DHCP-Options-for-DemoVCN.id
  display_name    = "public subnet-DemoVCN"
  dns_label       = "tfexsublb"
  
  prohibit_internet_ingress  = "false"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_vcn.export_DemoVCN.default_route_table_id
  security_list_ids = [
    oci_core_vcn.export_DemoVCN.default_security_list_id,
  ]
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

resource oci_core_subnet export_private-subnet-DemoVCN {
  #availability_domain = <<Optional value not found in discovery>>
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
  
  dhcp_options_id = oci_core_default_dhcp_options.export_Default-DHCP-Options-for-DemoVCN.id
  display_name    = "private subnet-DemoVCN"
  dns_label       = "tfexsubdbsys"
  
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.export_route-table-for-private-subnet-DemoVCN.id
  security_list_ids = [
    oci_core_security_list.export_security-list-for-private-subnet-DemoVCN.id,
  ]
  vcn_id = oci_core_vcn.export_DemoVCN.id
}


resource oci_core_nat_gateway export_NAT-gateway-DemoVCN {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
 
  display_name = "NAT gateway-DemoVCN"
 
  #route_table_id = <<Optional value not found in discovery>>
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

resource oci_core_internet_gateway export_Internet-gateway-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name = "Internet gateway-DemoVCN"
  enabled      = "true"

  #route_table_id = <<Optional value not found in discovery>>
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

resource oci_core_default_dhcp_options export_Default-DHCP-Options-for-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name     = "Default DHCP Options for DemoVCN"
  domain_name_type = "CUSTOM_DOMAIN"
 
  manage_default_resource_id = oci_core_vcn.export_DemoVCN.default_dhcp_options_id
  options {
    custom_dns_servers = [
    ]
    #search_domain_names = <<Optional value not found in discovery>>
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }
  options {
    #custom_dns_servers = <<Optional value not found in discovery>>
    search_domain_names = [
      "demovcn.oraclevcn.com",
    ]
    #server_type = <<Optional value not found in discovery>>
    type = "SearchDomain"
  }
}

resource oci_core_route_table export_route-table-for-private-subnet-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name = "route table for private subnet-DemoVCN"
  
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.export_NAT-gateway-DemoVCN.id
    #route_type = <<Optional value not found in discovery>>
  }
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "all-cdg-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.export_Service-gateway-DemoVCN.id
    #route_type = <<Optional value not found in discovery>>
  }
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

resource oci_core_default_route_table export_default-route-table-for-DemoVCN {
  compartment_id = var.compartment_ocid
 
  display_name = "default route table for DemoVCN"

  manage_default_resource_id = oci_core_vcn.export_DemoVCN.default_route_table_id
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.export_Internet-gateway-DemoVCN.id
    #route_type = <<Optional value not found in discovery>>
  }
}

resource oci_core_security_list export_security-list-for-private-subnet-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name = "security list for private subnet-DemoVCN"
  egress_security_rules {
    #description = <<Optional value not found in discovery>>
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value not found in discovery>>
    protocol  = "all"
    stateless = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "1521"
      min = "1521"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "7001"
      min = "7001"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "9001"
      min = "9001"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "9002"
      min = "9002"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "5901"
      min = "5901"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

resource oci_core_default_security_list export_Default-Security-List-for-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name = "Default Security List for DemoVCN"
  egress_security_rules {
    #description = <<Optional value not found in discovery>>
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value not found in discovery>>
    protocol  = "all"
    stateless = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
   ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "7001"
      min = "7001"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "9001"
      min = "9001"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    #icmp_options = <<Optional value not found in discovery>>
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "9002"
      min = "9002"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  ingress_security_rules {
    #description = <<Optional value not found in discovery>>
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
  manage_default_resource_id = oci_core_vcn.export_DemoVCN.default_security_list_id
}

resource oci_core_service_gateway export_Service-gateway-DemoVCN {
  compartment_id = var.compartment_ocid
  
  display_name = "Service gateway-DemoVCN"
  
  #route_table_id = <<Optional value not found in discovery>>
  services {
    service_id = data.oci_core_services.test_services.services.0.id
  }
  vcn_id = oci_core_vcn.export_DemoVCN.id
}

