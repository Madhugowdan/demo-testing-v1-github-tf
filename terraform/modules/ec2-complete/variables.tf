
variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  type    = string
  default = "app-webservice-github-workflow-terraform-tfstate-v1"
}

variable "key_name" {
  type    = string
  default = "ec2-tfstate/terraform.tfstate"
}


variable "db_table_name" {
  type    = string
  default = "terraform-state-locking-s3-tfstate"
}
variable "vpc_name" {
  type    = string
  default = "Int-app-WebservicePolicy-Private"
}

variable "subnet_name_1" {
  type    = list(string)
  default = ["intranet-0"]
}
variable "subnet_name_2" {
  type    = list(string)
  default = ["intranet-1"]
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 2
}


variable "instance_name_prefix" {
  type    = string
  default = "windows_ec2"
}

variable "ebs_size" {
  type    = number
  default = 100
}

variable "sg_ports_ingress" {
  type    = list(number)
  default = [443, 3386]
}


variable "sg_ports_egress" {
  type    = list(number)
  default = [443, 3386]
}

variable "root_volum" {
  type    = number
  default = 40
}