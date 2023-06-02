/* 
테라폼 클라우드를 사용할 시
variable "organization_name" {
  description = "name of organiztion in Terraform Cloud"
  type        = string
}

variable "workspaces_name" {
  description = "workspace name"
  type        = string
} 
*/


/*
variable "remote_state_bucket" {
  description = "remote state bucket name"
  type        = string
}
variable "remote_state_bucket_key" {
  description = "remote state stored location"
  type        = string
}
*/

/*
variable "project_name" {
  description = "name of project"
  type        = string
}
*/


variable "vpc_id" {
  description = "The VPC id"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The subnet id for instance"
  type        = string
  default     = null
}


variable "create_key" {
  description = "create key for instance"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "pem key name of instance"
  type        = string
  default     = null
}

variable "instance_profile_name" {
  description = "iam profile for instance"
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "creating instance profile"
  type        = bool
  default     = false
}

/* 
variable "instance_policy" {
  description = "policy of instance profile"
  type        = string
  default     = ""

} 
*/



variable "attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}
variable "create_inline_instance_policy" {
  description = "creating inline policy for instance"
  type        = bool
  default     = false
}

variable "inline_policy" {
  description = "inline policy for instance"
  type        = any
  default     = null
}


variable "specific_instance_ami" {
  description = "using ami"
  type        = bool
  default     = false
}

variable "instance_ami" {
  description = "please input ami id, if you uses specific ami id"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "instance name"
  type        = string
  default     = null
}

variable "instance_logic" {
  description = "input instance logic"
  type        = string
  default     = null
}


variable "instance_type" {
  description = "instance type"
  type        = string
  default     = null
}

variable "subnet_logic" {
  description = "subnet logic"
  type        = string
  default     = null
}

variable "using_eip" {
  description = "use eip with instance"
  type        = bool
  default     = false
}

variable "activate_pub_ip" {
  description = "activate public ip with instance"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = ""
}

variable "instance_add_tags" {
  description = "add tags to instance"
  type        = map(string)
  default     = {}
}

