# internal network - CIDR notation of a subnet
variable "cidr_net_int" {
  type      = string
  nullable  = false
  sensitive = false
}

# base name of resources and objects
variable "basename" {
  type      = string
  nullable  = false
  sensitive = false
}

# first node IP (last octet) - usually we start at five
variable "node_start_ip" {
  type      = string
  nullable  = false
  sensitive = false
  default   = "5"
}

# desired amount of control planes - 1 per default
variable "amount_cp" {
  type      = number
  nullable  = false
  sensitive = false
  default   = 1
}

# desired amount of workers - 1 per default
variable "amount_worker" {
  type      = number
  nullable  = false
  sensitive = false
  default   = 1
}

# if true -> cps are created with public IPs
variable "cpHasPubIP" {
  type      = bool
  nullable  = false
  sensitive = false
  default   = false
}

# if true -> workers are created with public IPs
variable "workerHasPubIP" {
  type      = bool
  nullable  = false
  sensitive = false
  default   = false
}

variable "ssh_keys" {
  type      = list
  nullable  = true
  sensitive = false
}