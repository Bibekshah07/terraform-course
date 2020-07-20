data "aws_region" "current" {

}

variable "region" {
  type = string
}

variable "subdomain_zone_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "aws_dns_zone_holder_profile_name" {
  type = string
}

variable "aws_dns_name" {
  type = string
}

variable "aws_dns_zone" {
  type = string
}
