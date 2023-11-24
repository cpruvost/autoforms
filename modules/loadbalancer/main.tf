### LB Variables
variable "compartment_ocid" {
    description = "The OCI Compartment ocid"
    type        = string
}

variable "subnet_id" {
    description = "the Subnet Id where we will create the LB"
    type        = string
}

variable "load_balancer_shape_details_maximum_bandwidth_in_mbps" {
    description = "The OCI LB Max Bandwith"  
    type        = number
    default = 100
}

variable "load_balancer_shape_details_minimum_bandwidth_in_mbps" {
    description = "The OCI LB Max Bandwith"  
    type = number
    default = 10
}

variable "private_ips" {
    description = "The OCI List of Container Instance Private IP Address "
    type        = list
}

variable "lb_name" {
    description = "The OCI LB Name"
    type        = string
    default     = "FORMS_FLEX_LB"
}


variable "lb_checker_health_forms_port" {
    description = "The OCI LB Health Checker Port"
    type        = string
    default     = "9001"
}

variable "lb_checker_url_forms_path" {
    description = "The OCI LB Health Checker URL"
    type        = string
    default     = "/forms/html/fsal.htm"
}

variable "lb_listener_forms_port" {
    description = "The OCI LB Listener Port"
    type        = number
    default     = 9001
}

variable "lb_backend_forms_port" {
    description = "The OCI LB Backend Port"
    type        = number
    default     = 9001
}

variable "lb_checker_health_reports_port" {
    description = "The OCI LB Health Checker Port"
    type        = string
    default     = "9002"
}

variable "lb_checker_url_reports_path" {
    description = "The OCI LB Health Checker URL"
    type        = string
    default     = "/reports/rwservlet/help?command=help"
}

variable "lb_listener_reports_port" {
    description = "The OCI LB Listener Port"
    type        = number
    default     = 9002
}

variable "lb_backend_reports_port" {
    description = "The OCI LB Backend Port"
    type        = number
    default     = 9002
}

###LB Resources
resource "oci_load_balancer" "flex_lb" {
  shape          = "flexible"
  compartment_id = var.compartment_ocid
  is_private = false

  subnet_ids = [
    var.subnet_id
  ]

  shape_details {
    #Required
    maximum_bandwidth_in_mbps = var.load_balancer_shape_details_maximum_bandwidth_in_mbps
    minimum_bandwidth_in_mbps = var.load_balancer_shape_details_minimum_bandwidth_in_mbps
  }

  display_name = var.lb_name
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = oci_load_balancer.flex_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = var.lb_checker_health_forms_port
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = var.lb_checker_url_forms_path
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  count = length(var.private_ips)  
  load_balancer_id = oci_load_balancer.flex_lb.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = element(var.private_ips, count.index)
  port             = var.lb_backend_forms_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = oci_load_balancer.flex_lb.id
  name                     = "forms"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
  port                     = var.lb_listener_forms_port
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "30"
  }
}

resource "oci_load_balancer_backend_set" "lb-bes2" {
  name             = "lb-bes2"
  load_balancer_id = oci_load_balancer.flex_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = var.lb_checker_health_reports_port
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = var.lb_checker_url_reports_path
  }
}

resource "oci_load_balancer_backend" "lb-be2" {
  count = length(var.private_ips)  
  load_balancer_id = oci_load_balancer.flex_lb.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes2.name
  ip_address       = element(var.private_ips, count.index)
  port             = var.lb_backend_reports_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_listener" "lb-listener2" {
  load_balancer_id         = oci_load_balancer.flex_lb.id
  name                     = "reports"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes2.name
  port                     = var.lb_listener_reports_port
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "30"
  }
}
