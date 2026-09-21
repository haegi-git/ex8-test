variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
  default     = ""
}

variable "azs" {
  type        = list(string)
  description = "The availability zones for the VPC"
  default     = []
}

variable "tag_header" {
  type        = string
  description = "The tag header for the VPC"
  default     = ""
}

variable "subnet_cidr" {
  type        = list(map(string))
  description = "The CIDR block for the subnets"
  default     = []
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name for kubernetes.io/cluster subnet tags"
  default     = ""
}

variable "owner" {
  type        = string
  description = "The owner of the VPC"
  default     = ""
}
