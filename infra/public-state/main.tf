module "network" {
  source     = "./network"
  vpc_cidr   = "10.0.0.0/16"
  vpc_name   = "std11-ex8-vpc"
  azs        = local.azs
  tag_header = "std11-"
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
