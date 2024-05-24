variable "nuon_id" {
  type        = string
  description = "The nuon id for this install. Used for naming purposes."
}

variable "tags" {
  type        = map(string)
  description = "List of custom tags to add to the install resources. Used for taxonomic purposes."
}

variable "location" {
  type        = string
  description = "The location to launch the cluster in"
}

variable "access_group_users" {
  type        = list(string)
  default     = ["jon@nuon.co"]
  description = "List of emails that will have access to the install."
}


// NOTE: if you would like to create an internal load balancer, with TLS, you will have to use the public domain.
variable "internal_root_domain" {
  type        = string
  description = "The internal root domain."
}

variable "public_root_domain" {
  type        = string
  description = "The public root domain."
}

// cluster configuration
variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster. Will use the install ID by default."
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version to use for the EKS cluster."
  default     = "1.28"
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2_v2"
  description = "The image size."
}

variable "node_count" {
  type        = number
  default     = 2
  description = "The minimum number of nodes in the managed node pool."
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "The EC2 instance types to use for the EKS cluster."
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "template" {
  type        = string
  description = "What template to use."
  default     = "fully_managed_single_subnet"
  validation {
    condition     = contains(["fully_managed_single_subnet", "fully_managed_multiple_subnets"], var.template)
    error_message = "${var.template} is not a valid template name."
  }
}

variable "a_subnet_delegations" {
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))

  default = []
}

variable "b_subnet_delegations" {
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))

  default = []
}

variable "db_subnet_delegations" {
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))

  default = [
    {
      name = "sql"
      service_delegation = {
        name = "Microsoft.Sql/servers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    },
    {
      name = "postgresql"
      service_delegation = {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    },
    {
      name = "mysql"
      service_delegation = {
        name = "Microsoft.DBforMySQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  ]
}
