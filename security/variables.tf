
variable "project_name" {
  type        = string
  description = "project name"
}


variable "env_name" {
  type        = string
  description = "It describes enviornment of this project"
}

variable "vpc_name" {
  description = "name of VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "cidr of VPC"
  type        = string
}


variable "avaliable_zones" {
  description = "The az for public subents"
  type        = list(string)
}


variable "public_network_address" {
  description = "The ip range for public subents"
  type        = list(string)
}

variable "public_network_logic" {
  description = "The ip range for public subents"
  type        = list(string)
}


variable "private_network_address" {
  description = "The ip range for private subents"
  type        = list(string)
  default     = []
}

variable "private_network_logic" {
  description = "The name for public subents"
  type        = list(string)
  default     = []
}


variable "using_nat" {
  description = "use nat gateway to connect Public internet"
  type        = bool
}

variable "nat_gateway_cidr" {
  description = "please input nat gateway destination cidr"
  type        = string

}
variable "using_public_transit" {
  description = "use nat gateway to connect from public to tgw"
  type        = bool

}

variable "using_transit" {
  description = "use nat gateway to connect Public internet"
  type        = bool

}

variable "nat_gateway_count" {
  description = "The amount of nat gateway"
  type        = number

}


###################################################################################################################
#bastion
###################################################################################################################

variable "create_key" {
  description = "create key for instance"
  type        = bool

}

variable "key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "specific_instance_ami" {
  description = "using ami"
  type        = bool
}


variable "using_eip" {
  description = "value of using eip"
  type        = bool
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "instance_name" {
  description = "instance name"
  type        = string
}

variable "subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}


###################################################################################################################
# cpp server
###################################################################################################################

variable "cpp_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "cpp_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "cpp_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "cpp_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "cpp_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "cpp_specific_instance_ami" {
  description = "using ami"
  type        = bool
}


variable "cpp_using_eip" {
  description = "value of using eip"
  type        = bool
}

variable "cpp_instance_type" {
  description = "instance type"
  type        = string
}

variable "cpp_instance_name" {
  description = "instance name"
  type        = string
}

variable "cpp_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "cpp_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "cpp_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}

variable "cpp_instance_ami" {
  description = "please input ami id, if you uses specific ami id"
  type        = string
  default     = null
}


###################################################################################################################
# agent server -window
###################################################################################################################

variable "window_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "window_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "window_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "window_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "window_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "window_specific_instance_ami" {
  description = "using ami"
  type        = bool
}


variable "window_using_eip" {
  description = "value of using eip"
  type        = bool
}

variable "window_instance_type" {
  description = "instance type"
  type        = string
}

variable "window_instance_name" {
  description = "instance name"
  type        = string
}

variable "window_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "window_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "window_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}



variable "window_instance_ami" {
  description = "please input ami id, if you uses specific ami id"
  type        = string
  default     = null
}



###################################################################################################################
# agent server -amazon linux2
###################################################################################################################

variable "alinux_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "alinux_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "alinux_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "alinux_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "alinux_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "alinux_specific_instance_ami" {
  description = "using ami"
  type        = bool
}


variable "alinux_using_eip" {
  description = "value of using eip"
  type        = bool
}

variable "alinux_instance_type" {
  description = "instance type"
  type        = string
}

variable "alinux_instance_name" {
  description = "instance name"
  type        = string
}

variable "alinux_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "alinux_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "alinux_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}

variable "alinux_instance_ami" {
  description = "please input ami id, if you uses specific ami id"
  type        = string
  default     = null
}


