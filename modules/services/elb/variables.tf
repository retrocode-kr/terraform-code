variable "vpc_name" {
  description = "vpc name"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "subnet ids for alb"
  type        = list(string)
  default     = []
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners"
  type        = any
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP"
  type        = any
  default     = []
}

variable "https_listener_rules" {
  description = "A list of maps describing the HTTP rule"
  type        = any
  default     = []
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer."
  type        = string
  default     = "ipv4"
}

variable "http_tcp_listener_rules" {
  description = "A list of maps describing the HTTP or TCP rule"
  type        = any
  default     = []
}


variable "tags" {
  description = "tags of all resources"
  type        = map(string)
  default     = {}
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created."
  type        = any
  default     = null
}

variable "target_group_tags" {
  description = "A map of tags to add to all target groups"
  type        = map(string)
  default     = null
}

variable "https_listener_rules_tags" {
  description = "A map of tags to add to all https listener rules"
  type        = map(string)
  default     = null
}

variable "http_tcp_listeners_tags" {
  description = "A map of tags to add all http listeners"
  type        = map(string)
  default     = null
}

variable "elb_name" {
  description = "elb name"
  type        = string
  default     = null
}

variable "elb_logic" {
  description = "elb logic"
  type        = string
  default     = null
}

variable "elb_type" {
  description = "elb type"
  type        = string
  default     = null
}

variable "elb_tg_name" {
  description = "elb target group name"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
  default     = null
}
variable "extra_ssl_certs" {
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward)."
  type        = list(map(string))
  default     = []
}

variable "listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}
