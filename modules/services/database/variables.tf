variable "project_name" {
  description = "name of project"
  type        = string
  default     = null

}

variable "env_name" {
  description = "env name"
  type        = string
  default     = null
}

variable "rds_type" {
  description = "true, if want to create aurora db"
  type        = string
  default     = null
}

variable "database_subnet_group_name" {
  description = "db subnet name"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "database availability zones"
  type        = list(string)
  default     = []

}

variable "rds_identifier" {
  description = "name of RDS"
  type        = string
  default     = null

}

variable "rds_parameter_group_name" {
  description = "rds parameter group name"
  type        = string
  default     = null
}

variable "name" {
  description = "aurora cluster name"
  type        = string
  default     = null
}



variable "skip_final_snapshot" {
  description = "creat final snapshot before delete Dastabase"
  type        = bool
  default     = false

}


variable "allocated_storage" {
  description = "size of allocated storage"
  type        = number
  default     = null

}

variable "engine" {
  description = "engine name"
  type        = string
  default     = null

}

variable "engine_version" {
  description = "the engine version"
  type        = string
  default     = null

}

variable "license_model" {
  description = "the license_model"
  type        = string
  default = "license-included"
}

variable "instance_class" {
  description = "the spec of instance class"
  type        = string
  default     = null

}

variable "instances_use_identifier_prefix" {
  description = "Determines whether cluster instance identifiers are used as prefixes"
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "Map of IAM roles and supported feature names to associate with the cluster"
  type        = map(map(string))
  default     = {}
}
variable "db_name" {
  description = "database_name"
  type        = string
  default     = null
}

variable "username" {
  description = "master user name"
  type        = string
  default     = null

}

variable "password" {
  description = "password of master user"
  type        = string
  default     = null
}

variable "port" {
  description = "port number"
  type        = number
  #my sql port number
  default = null
}

variable "allow_major_version_upgrade" {
  description = "check auto upgrade for major version"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "check auto upgrade for minor version upgrade"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}


variable "iam_database_authentication_enabled" {
  description = "enabled iam auth to connect to DB"
  type        = bool
  default     = false
}


variable "backup_retention_period" {
  description = "backup maintance period"
  type        = number
  default     = null
}

variable "backup_window" {
  description = "backup time"
  type        = string
  default     = null

}
variable "instances" {
  description = "input values to  aurora db instances"
  type        = map(any)
  default     = {}
}

variable "endpoints" {
  description = "customized endpoints of aurora db cluster"
  type        = map(any)
  default     = {}

}


variable "enabled_cloudwatch_logs_exports" {
  description = "enabled which kind log export to cloud watch"
  type        = list(string)
  default     = []
}

variable "monitoring_interval" {
  description = "how much interal for monitoring"
  type        = number
  default     = 0
}

variable "preferred_maintenance_window" {
  description = "input prefer maintenance window time"
  type        = string
  default     = null
}

variable "create_monitoring_role" {
  description = "create monitoring role"
  type        = bool
  default     = false
}

variable "iam_role_use_name_prefix" {
  description = "boolean of using prefix for role"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "role name for enhanced monitoring"
  type        = string
  default     = null
}



variable "iam_role_description" {
  description = "description of monitoring role"
  type        = string
  default     = null
}

variable "iam_role_path" {
  description = "path of monitoring role"
  type        = string
  default     = null
}

variable "iam_role_managed_policy_arns" {
  description = "arn of monitoring role"
  type        = list(string)
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the monitoring role"
  type        = string
  default     = null
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any policies the monitoring role has before destroying it"
  type        = bool
  default     = null
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the monitoring role"
  type        = number
  default     = null
}


variable "enable_global_write_forwarding" {
  description = "Whether cluster should forward writes to an associated global cluster. Applied to secondary clusters to enable them to forward writes to an `aws_rds_global_cluster`'s primary cluster"
  type        = bool
  default     = null
}



variable "publicly_accessible" {
  description = "configure publicy accessible"
  type        = bool
  default     = false
}

variable "db_add_tags" {
  description = "tags add to database"
  type        = map(string)
  default     = {}
}

variable "create_db_cluster_parameter_group" {
  description = "create parameter or not"
  type        = bool
  default     = false
}

variable "db_cluster_parameter_group_use_name_prefix" {
  description = "Parameter group name"
  type        = bool
  default     = false
}

variable "db_cluster_parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_family" {
  description = "parameter family"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
  default     = []
}


variable "db_cluster_parameter_group_description" {
  description = "db cluster's parameter description "
  type        = string
  default     = null
}

variable "create_db_parameter_group" {
  description = "create parameter or not"
  type        = bool
  default     = false
}

variable "db_parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = null
}

variable "db_parameter_group_family" {
  description = "parameter family"
  type        = string
  default     = null
}

variable "db_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
  default     = []
}


variable "db_parameter_group_description" {
  description = "db cluster's parameter description "
  type        = string
  default     = false
}

variable "deletion_protection" {
  description = "value of deletion protection"
  default     = true
}
