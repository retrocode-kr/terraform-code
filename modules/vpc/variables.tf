variable "project_name" {
  type        = string
  description = "please input project name"
  default     = null
}

variable "env_name" {
  type        = string
  description = "It describes enviornment of this project"
  default     = null
}

variable "vpc_name" {
  description = "name of VPC"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "cidr of VPC"
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "tags of project"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "tags of project"
  type        = map(string)
  default     = null
}

variable "avaliable_zones" {
  description = "The az for public subents"
  type        = list(string)
  default     = []
}


variable "public_network_address" {
  description = "The ip range for public subents"
  type        = list(string)
  default     = []
}

variable "public_network_logic" {
  description = "The ip range for public subents"
  type        = list(string)
  default     = []
}

variable "eks_public_network_address" {
  description = "The ip range for public subents"
  type        = list(string)
  default     = []
}

variable "eks_public_network_logic" {
  description = "The ip range for public subents"
  type        = list(string)
  default     = []
}

variable "add_eks_public_subnet_tags" {
  description = "add tags to eks public subnet"
  type        = map(string)
  default     = {}
}

variable "add_public_subnet_tags" {
  description = "add tags to public subnet"
  type        = map(string)
  default     = null
}

variable "using_public_transit" {
  description = "use nat gateway to connect from public to tgw"
  type        = bool
  default     = false
}

variable "public_transit_gateways" {
  description = "please input transit gateway destination cidr and id"
  type        = list(map(any))
  default     = []
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
  description = "The ip range for private subents"
  type        = list(string)
  default     = []
}

variable "eks_private_network_logic" {
  description = "The name for public subents"
  type        = list(string)
  default     = []
}


variable "add_eks_private_subnet_tags" {
  description = "add tags to eks private subnet"
  type        = map(string)
  default     = {}
}


variable "using_nat" {
  description = "use nat gateway to connect Public internet"
  type        = bool
  default     = false
}

variable "nat_gateway_cidr" {
  description = "please input nat gateway destination cidr"
  type        = string
  default     = null
}



variable "using_transit" {
  description = "use transit gateway to connect Public internet"
  type        = bool
  default     = false
}


variable "private_transit_gateways" {
  description = "please input transit gateway destination cidr and id"
  type        = list(map(any))
  default     = []
}


variable "add_private_subnet_tags" {
  description = "add tags to private subnet"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_name" {
  description = "value of db subnet group name"
  type        = string
  default     = null
}

variable "db_network_address" {
  description = "The ip range for DB subents"
  type        = list(string)
  default     = []
}

variable "db_network_logic" {
  description = "The name for public subents"
  type        = list(string)
  default     = []

}


variable "nat_gateway_count" {
  description = "The amount of nat gateway"
  type        = number
  default     = 0
}
