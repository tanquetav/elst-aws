variable "name" {
  default     = "demo"
  description = "The name of the project"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC"
}

variable "worker_nodes" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t3a.medium"
}
