# Launch Template & UserData
resource "aws_launch_template" "asg_lt" {
  name_prefix            = "${var.tag_header}-"
  image_id               = var.ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups

  # 기본 버전 지정 방법
  default_version = var.default_version != "latest" ? tostring(var.default_version) : null

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_header}asg-node-instance"
    }
  }
}
