variable "project_name" {
  type = string
}

variable "avaliable_zones" {
  description = "The az for public subents"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}


variable "create_key" {
  description = "if want to create pair-key, input true"
  type        = bool
}

variable "key_name" {
  description = "if will create key, must input key name"
  type        = string
}

variable "launch_template_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_logic" {
  description = "input instance logic"
  type        = string
}

variable "specific_ami" {
  description = "if have a specific ami, input here"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "input instance type"
  type        = string
}

variable "device_name" {
  type    = string
  default = "/dev/xvda"
}

variable "volume_size" {
  description = "ammount of ebs size"
  type        = number
}

variable "create_instance_profile" {
  description = "creating instance profile"
  type        = bool
}

variable "instance_profile_name" {
  description = "iam profile for instance"
  type        = string

}

variable "add_security_groups_ids" {
  description = "input security group, if need to add more"
  type        = list(string)
  default     = []
}

variable "health_check_type_elb" {
  description = "use elb on health check type for auto scaling"
  type        = bool

}

variable "autoscaling_group_name" {
  type = string

}

variable "instance_policy" {
  description = "policy of instance profile"
  type        = string
  default     = ""

}

variable "autoscali_desired_capacity" {
  type    = number
  default = 1
}
variable "autoscali_max_size" {
  type = number
}

variable "autoscali_min_size" {
  type = number
}

variable "lb_target_group_arn" {
  type = list(string)

}
/*
variable "vpc_zone_identifier" {
  type = list(string)

}
*/
variable "suspended_processes" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = ""
}

variable "ami_name" {
  type = string

}

variable "tags" {
  type    = map(string)
  default = {}
}
