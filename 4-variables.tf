variable "customer" {
    type = string
    default = "amin"
}
variable "env_name" {
    type = string
    default = "development"
}

variable "cidr_block_vpc" {
    type = string
    default = "10.0.0.0/16"
}

#2 Public subnets
variable "cidr_block_public_subnet1" {
    type = string
    default = "10.0.1.0/24"
}

variable "cidr_block_public_subnet2" {
    type = string
    default = "10.0.2.0/24"
}

#2 Private subnets with nat
variable "cidr_block_private_sub_a1" {
    type = string
    default = "10.0.3.0/24"
}
variable "cidr_block_private_sub_b1" {
    type = string
    default = "10.0.4.0/24"
}

#2 private regular subnets
variable "cidr_block_private_sub_a2" {
    type = string
    default = "10.0.5.0/24"
}

variable "cidr_block_private_sub_b2" {
    type = string
    default = "10.0.6.0/24"
}