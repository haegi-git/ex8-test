data "aws_availability_zones" "available_az" {
  state = "available"
}
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_security_group" "external_alb_sg" {
  filter {
    name = "tag:Name"
    values = [
      "${local.tag_header}external-alb-sg"
    ]
  }
}

output "info" {
  value = [
  data.aws_security_groups.security_groups.ids, ]
}
