variable "create_key" {
  description = "create key for AWS resources"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "pem key name of AWS resources"
  type        = string
  default     = null
}
