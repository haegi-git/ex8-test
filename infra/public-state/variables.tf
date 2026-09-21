variable "owner" {
  type        = string
  description = "The owner of the VPC"
  default     = "std11"
}

variable "key_name" {
  type        = string
  description = "The key name for the EKS"
  default     = "std11-ex8-key"
}
variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
  default     = "std11-ex8-vpc"
}
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "azs" {
  type        = list(string)
  description = "The availability zones for the VPC"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}
variable "subnet_cidr" {
  type        = list(map(string))
  description = "The CIDR block for the subnets"
  default = [{
    eu-central-1a = "10.0.1.0/24"
    eu-central-1b = "10.0.2.0/24"
    eu-central-1c = "10.0.3.0/24"
    },
    {
      eu-central-1a = "10.0.11.0/24"
      eu-central-1b = "10.0.12.0/24"
      eu-central-1c = "10.0.13.0/24"
  }]
}
variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
  default     = "std11-eks-cluster"
}
variable "tag_header" {
  type        = string
  description = "The tag header for the VPC"
  default     = "std11-"
}

variable "environment" {
  type        = string
  description = "The environment of the VPC"
  default     = "dev"
}
