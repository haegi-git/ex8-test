# Launch Template & UserData
resource "aws_launch_template" "asg_lt" {
  name_prefix            = "${var.tag_header}-"
  image_id               = var.ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups

  # 기본 버전 지정 방법
  update_default_version = var.default_version == "latest" ? true : false
  default_version        = var.default_version != "latest" ? tostring(var.default_version) : null
  # ------------------------------------------------------------
  iam_instance_profile {
    # name = 역할 이름
    name = aws_iam_instance_profile.node_profile_asg.name
  }
  # CodeDeploy 설치 스크립트
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              # ruby: CodeDeploy서비스 개발 언어, codedeploy-agent 설치를 위해 반드시 필요
              dnf install -y ruby wget docker

              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              cd /tmp
              wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto

              systemctl start codedeploy-agent
              systemctl enable codedeploy-agent
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_header}asg-node-instance"
    }
  }
}


# Auto Scaling Group

resource "aws_autoscaling_group" "asg" {
  name                = "${var.tag_header}codedeploy-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }
}
