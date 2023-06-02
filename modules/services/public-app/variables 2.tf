variable "project_name" {
  description = "name of project"
  type = string
  default = null
  
}

variable "specific_bastion_az" {
  description = "az of bastion"
  type = list(string)
  default = null
}

variable "bastion_instance_names" {
  description = "instance names"
  type = list(string)
  default = null
}


variable "bastion_instance_type" {
  description = "cicd instance type "
  type = string
  default = null
}

variable "create_cicd_instance" {
  description = "create cicd or not"
  type = bool
  default = null
}

variable "specific_cicd_az" {
  description = "az of cicd"
  type = list(string)
  default = null
}

variable "cicd_instance_names" {
  description = "names of cicd"
  type = list(string)
  default = null
}

variable "cicd_instance_type" {
  description = "cicd instance type"
  type = string
  default = null
}

variable "remote_state_bucket" {
  description = "remote vpc bucket"
  type = string
  default = null
}

variable "vpc_remote_state_bucket_key" {
  description = "remote vpc bucket"
  type = string
  default = null
}

variable "bastion_associate_public_ip_address" {
  description = "check use public ip or not"
  type = bool
  default = null
}

variable "bastion_key_name" {
  description = "pem key name of instance"
  type = string
  default = null
}

variable "bastion_root_block_device" {
  description = "information of root ebs"
  type = list(any)
  default = null
}

variable "cicd_associate_public_ip_address" {
  description = "check use public ip or not"
  type = bool
  default = null
}

variable "cicd_key_name" {
  description = "pem key name of instance"
  type = string
  default = null
}

variable "cicd_root_block_device" {
   description = "information of root ebs"
  type = list(any)
  default = null
}