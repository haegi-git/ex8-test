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


# #############################################################################
# CodeDeploy Application & Deployment Group
# #############################################################################

resource "aws_codedeploy_app" "app" {
  # 배포 대상 정의: Server / Lambda / ECS
  # codedeploy란? AWS CodeDeploy는 소프트웨어 배포를 자동화하는 서비스로, 애플리케이션 배포를 쉽고 안전하게 관리할 수 있도록 도와줍니다.
  name             = "${var.tag_header}asg-codedeploy-app"
  compute_platform = "Server"
}
resource "aws_codedeploy_deployment_group" "deployment_group" {
  deployment_group_name = "${var.tag_header}asg-codedeploy-deployment-group" # 배포 그룹 이름
  app_name              = aws_codedeploy_app.app.name                        # CodeDeploy 애플리케이션 연결
  service_role_arn      = aws_iam_role.codedeploy_role.arn                   # CodeDeploy 역할 연결
  autoscaling_groups    = [aws_autoscaling_group.asg.name]                   # 배포 대상 정의

  deployment_config_name = "CodeDeployDefault.AllAtOnce" # 배포 구성 이름
  # 배포 전략 지정
  # "CodeDeployDefault.AllAtOnce": 타겟 인스턴스 전체에 동시에 한 번에 배포하는 방식
  # "OneAtATime": 타겟 인스턴스 하나씩 순차적으로 배포하는 방식
  # "HalfAtATime": 대상 인스턴스의 50%를 먼저 배포 후 나머지 배포
}

# #############################################################################
# 연결 리소스 생성 및 CodePipeline 리소스 생성
# #############################################################################
# AWS - GitHub 간 CodeStart Connection 생성

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.tag_header}github-connection"
  provider_type = "GitHub"
}

# #############################################################################
# AWS CodePipeline 생성
# #############################################################################
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.tag_header}asg-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.id

    type = "S3"
  }
  # source stage
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"                      # 액션 제공자(aws에서 제공하는 서비스 활용)
      provider         = "CodeStarSourceConnection" # github v2액션과 연동 표준인 codestarconnections 사용
      version          = "1"
      output_artifacts = ["source_output"] # ZIP 소스 압축파일을 다음 스테이지로 전달할 전달용 아티펙트 이름 선언
      # Github 연동을 위한 속성값 정의
      configuration = {
        # github와 codeDeploy를 연결하는 연결 객체 정의
        ConnectionArn = aws_codestarconnections_connection.github_connection.arn
        # 깃허브 레포 이름
        FullRepositoryId = "haegi-git/ex8-test"
        BranchName       = "main"
      }
    }
  }
  # Deploy stage
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"        # 액션 제공자(aws에서 제공하는 서비스 활용)
      provider        = "CodeDeploy" # 배포에 사용할 aws 서비스 지정 (CodeDeploy)
      version         = "1"
      input_artifacts = ["source_output"] # 이전 스테이지에서 생성된 아티펙트 이름 선언
      # CodeDeploy 배포 설정을 위한 속성값 정의
      configuration = {
        ApplicationName     = aws_codedeploy_app.app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      }
    }
  }
}
