
variable "project_name" {
  description = "value of project name"
  type        = string
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
  description = "The network logic for public subents"
  type        = list(string)
}


variable "eks_public_network_address" {
  description = "The ip range for eks public subents"
  type        = list(string)
}

variable "eks_public_network_logic" {
  description = "The ip network logic for public subents"
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

variable "eks_private_network_address" {
  description = "The ip range for eks public subents"
  type        = list(string)
}

variable "eks_private_network_logic" {
  description = "The ip network logic for public subents"
  type        = list(string)
}

variable "db_network_address" {
  description = "The ip range for DB subents"
  type        = list(string)

}

variable "db_network_logic" {
  description = "The name for public subents"
  type        = list(string)


}

variable "db_subnet_group_name" {
  description = "value of db subnet group name"
  type        = string
}

variable "using_nat" {
  description = "use nat gateway to connect Public internet"
  type        = bool
}

variable "nat_gateway_cidr" {
  description = "please input nat gateway destination cidr"
  type        = string
}

variable "nat_gateway_count" {
  description = "The number of nat gateway"
  type        = number
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

/* variable "subnet_logic" {
  description = "subnet logic for instance"
  type        = string
} */


variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}


###################################################################################################################
#pri bastion
###################################################################################################################

variable "pri_bastion_create_key" {
  description = "create key for instance"
  type        = bool

}

variable "pri_bastion_key_name" {
  description = "pem key name of instance"
  type        = string

}
variable "pri_bastion_create_instance_profile" {
  description = "create instance profile for instance"
  type        = bool
}

variable "pri_bastion_instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "pri_bastion_using_eip" {
  description = "value of using eip"
  type        = bool
}

variable "pri_bastion_specific_instance_ami" {
  description = "using ami"
  type        = bool
}

variable "pri_bastion_instance_type" {
  description = "instance type"
  type        = string
}

variable "pri_bastion_instance_name" {
  description = "instance name"
  type        = string
}

variable "pri_bastion_root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
}

variable "pri_bastion_instance_add_tags" {
  description = "Additional tags for instance"
  type        = map(string)

}



###################################################################################################################
# aurora
###################################################################################################################
variable "rds_type" {
  description = "true, if want to create aurora db"
  type        = string

}

variable "database_subnet_group_name" {
  description = "db subnet name"
  type        = string
  default     = null
}


variable "db_cluster_name" {
  description = "aurora cluster name"
  type        = string

}
variable "skip_final_snapshot" {
  description = "creat final snapshot before delete Dastabase"
  type        = bool

}

variable "engine" {
  description = "engine name"
  type        = string
}


variable "engine_version" {
  description = "the engine version"
  type        = string

}

variable "instance_class" {
  description = "the spec of instance class"
  type        = string


}

variable "db_instances" {
  description = "input values to  aurora db instances"
  type        = map(any)
  default     = {}
}


variable "db_name" {
  description = "database_name"
  type        = string
}

variable "iam_database_authentication_enabled" {
  description = "enabled iam auth to connect to DB"
  type        = bool
}


variable "username" {
  description = "master user name"
  type        = string
}

# variable "password" {
#   description = "password of master user"
#   type        = string
# }

variable "backup_retention_period" {
  description = "backup maintance period"
  type        = number
}

variable "backup_window" {
  description = "backup time"
  type        = string

}

variable "port" {
  description = "port number"
  type        = number

}

variable "enabled_cloudwatch_logs_exports" {
  description = "enabled which kind log export to cloud watch"
  type        = list(string)
}

variable "db_add_tags" {
  description = "tags add to database"
  type        = map(string)
}

variable "create_db_cluster_parameter_group" {
  description = "create parameter or not"
  type        = bool
}

variable "db_cluster_parameter_group_name" {
  description = "Parameter group name"
  type        = string
}

variable "db_cluster_parameter_group_family" {
  description = "parameter family"
  type        = string
}

variable "db_cluster_parameter_group_description" {
  description = "db cluster's parameter description "
  type        = string
}
variable "db_cluster_parameter_group_parameters" {
  description = "db cluster's parameter description "
  type        = list(map(string))
}

variable "create_db_parameter_group" {
  description = "create parameter or not"
  type        = bool

}

variable "db_parameter_group_name" {
  description = "Parameter group name"
  type        = string

}

variable "db_parameter_group_family" {
  description = "parameter family"
  type        = string

}


variable "db_parameter_group_description" {
  description = "db cluster's parameter description "
  type        = string

}


variable "db_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
}
