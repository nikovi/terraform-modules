variable "name" {
  description = "vpc name"
  type = string
  default = "nikovi-vpc"
}

variable "enable_ipam" {
  description = "enable IPAM vpc config"
  type = bool
  default = false
}