module "network" {
  source           = "./network"
  vpc_cidr         = "10.0.0.0/16"
  vpc_name         = "std11-ex8-vpc"
  azs              = local.azs
  tag_header       = "std11-"
  eks_cluster_name = "std11-eks-cluster"
  subnet_cidr = [{
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

# module "eks" {
#   source             = "./eks"
#   tag_header         = "std11-"
#   vpc_id             = module.network.vpc_id
#   node_policies      = local.node_policies
#   private_subnet_ids = module.network.private_subnet_ids
# }

