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

# SG 는 network/sg.tf 에서 생성 후 module.network 로 넘김.
# 같은 apply 안에서 data 로 찾으면 아직 없어서 실패함.
