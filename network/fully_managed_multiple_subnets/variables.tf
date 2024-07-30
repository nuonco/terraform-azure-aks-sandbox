variable "resource_group_name" {
  type = string
}

variable "a_subnet_delegations" {
  type = list(any)
}

variable "b_subnet_delegations" {
  type = list(any)
}

variable "db_subnet_delegations" {
  type = list(any)
}
