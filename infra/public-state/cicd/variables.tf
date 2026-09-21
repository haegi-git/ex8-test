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
