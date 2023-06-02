variable "project_name" {
  type        = string
  description = "Project name"
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

variable "nat_gateway_count" {
  description = "value of nat gateway count"
  type        = number
}

variable "nat_gateway_cidr" {
  description = "please input nat gateway destination cidr"
  type        = string
}

variable "using_transit" {
  description = "use nat gateway to connect Public internet"
  type        = bool
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
#jenkins
###################################################################################################################

variable "jenkins_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "jenkins_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "jenkins_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "jenkins_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "jenkins_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "jenkins_specific_instance_ami" {
  description = "using ami"
  type        = bool
}


variable "jenkins_instance_type" {
  description = "instance type"
  type        = string
}

variable "jenkins_instance_name" {
  description = "instance name"
  type        = string
}

variable "jenkins_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "jenkins_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "jenkins_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}


###################################################################################################################
#stg jenkins
###################################################################################################################

variable "stg_jenkins_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "stg_jenkins_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "stg_jenkins_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "stg_jenkins_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "stg_jenkins_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}

variable "stg_jenkins_specific_instance_ami" {
  description = "using ami"
  type        = bool
}

variable "stg_jenkins_instance_type" {
  description = "instance type"
  type        = string
}

variable "stg_jenkins_instance_name" {
  description = "instance name"
  type        = string
}

variable "stg_jenkins_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "stg_jenkins_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "stg_jenkins_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}

###################################################################################################################
#prd jenkins
###################################################################################################################

variable "prd_jenkins_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "prd_jenkins_key_name" {
  description = "pem key name of instance"
  type        = string

}

variable "prd_jenkins_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}


variable "prd_jenkins_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "prd_jenkins_attach_policy_arn" {
  description = "aws policy name that will be attached to instance"
  type        = list(string)
  default     = []

}


variable "prd_jenkins_instance_type" {
  description = "instance type"
  type        = string
}


variable "prd_jenkins_instance_name" {
  description = "instance name"
  type        = string
}

variable "prd_jenkins_specific_instance_ami" {
  description = "using ami"
  type        = bool
}
variable "prd_jenkins_subnet_logic" {
  description = "subnet logic for instance"
  type        = string
}


variable "prd_jenkins_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "prd_jenkins_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}

###################################################################################################################
#jenkins ALB
###################################################################################################################

variable "elb_name" {
  description = "elb name"
  type        = string
}
variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP"
  type        = any
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing"
  type        = bool

}

variable "elb_logic" {
  description = "elb logic"
  type        = string
}


variable "elb_type" {
  description = "elb type"
  type        = string
}
