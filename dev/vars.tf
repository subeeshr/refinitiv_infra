#SET THIS LATER IN EACH ENV's LOCAL tfvars - variable "env" { type = "list" default = [ "DEV","QA","UAT" ] }

variable "env" { default = "dev" }

variable "elb_internal" { default = "true" }
variable "project" { default = "refinitiv"}


variable "s3_bucket_name" { default = "my-log-test-bucket" }
variable "s3_bucket_acl" { default = "private" }
variable "aws_region" { default = "eu-west-1"}

variable "azs" {
  default = "eu-west-1a"
}

variable "subnet_cidr" { default = "10.0.0.0/28" }
variable "vpc_cidr" { default = "10.0.0.0/16"}

variable "ami_id" { default = "ami-08935252a36e25f85" }
variable "instance_type" { default = "t2.micro" }
variable "refinitiv_ami_name" { default = "refinitiv-ami" }
variable "instance_count" { default = "1"}
variable "key_name" {default = "fnrdev"}
#variable "subnet_id" {}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = "~/.ssh/fnrdev.pub"
}
