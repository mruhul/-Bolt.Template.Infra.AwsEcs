variable "group" {
  type    = string
  default = "__group__"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "az_count" {
  type    = number
  default = __az_count__
}

variable "vpc_cidr" {
  type    = string
  default = "__vpc_cidr__"
}
