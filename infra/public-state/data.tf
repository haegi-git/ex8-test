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

data "aws_security_group" "security_group_alb" {
  filter {
    name = "tag:Name"
    values = [
      "${local.tag_header}alb-sg"
    ]
  }
}

data "aws_security_group" "security_group_ssh" {
  filter {
    name = "tag:Name"
    values = [
      "${local.tag_header}ssh-sg"
    ]
  }
}

data "aws_security_groups" "security_groups" {
  filter {
    name = "tag:Name"
    values = [
      "${local.tag_header}external-alb-sg",
      "${local.tag_header}ssh-sg"
    ]
  }
}

output "info" {
  value = [
    data.aws_security_group.external_alb_sg.id,
    data.aws_security_group.internal_ssh_sg.id,
    data.aws_security_groups.security_groups.ids,
  ]
}
