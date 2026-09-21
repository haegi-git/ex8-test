variable "tag_header" {
  type        = string
  description = "The tag header for the pipeline bucket"
  default     = ""
}
variable "owner" {
  type        = string
  description = "The owner of the pipeline bucket"
  default     = ""
}
variable "environment" {
  type        = string
  description = "The environment of the pipeline bucket"
  default     = ""
}
variable "ami_id" {
  type        = string
  description = "The AMI ID for the launch template"
  default     = ""
}
variable "key_name" {
  type        = string
  description = "The key name for the launch template"
  default     = ""
}
variable "security_groups" {
  type        = list(string)
  description = "The security groups for the launch template"
  default     = []
}
variable "default_version" {
  type        = string
  description = "The default version for the launch template"
  default     = ""
}

variable "ec2_policy_arns" {
  type        = set(string)
  description = "The policy ARNs for the launch template"
  default     = toset([])
}
