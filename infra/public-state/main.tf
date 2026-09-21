module "network" {
  source           = "./network"
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  azs              = local.azs
  tag_header       = local.tag_header
  owner            = var.owner
  eks_cluster_name = var.eks_cluster_name
  subnet_cidr      = var.subnet_cidr

}

module "cicd" {
  source             = "./cicd"
  tag_header         = local.tag_header
  owner              = var.owner
  environment        = var.environment
  ami_id             = local.ami_id
  key_name           = var.key_name
  security_groups    = module.network.security_group_ids
  default_version    = var.default_version
  ec2_policy_arns    = local.ec2_policy_arns
  private_subnet_ids = module.network.private_subnet_ids
}

# module "eks" {
#   source             = "./eks"
#   tag_header         = "std11-"
#   vpc_id             = module.network.vpc_id
#   node_policies      = local.node_policies
#   private_subnet_ids = module.network.private_subnet_ids
# }
