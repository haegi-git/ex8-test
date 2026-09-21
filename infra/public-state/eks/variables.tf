variable "tag_header" {
  type        = string
  description = "The tag header for the EKS"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID for the EKS"
  default     = ""
}

variable "node_policies" {
  type        = list(string)
  description = "The node policies for the EKS"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs for the EKS"
  default     = []
}

variable "key_name" {
  type        = string
  description = "The key name for the EKS"
  default     = ""
}
