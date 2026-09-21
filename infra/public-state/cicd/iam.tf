# #############################################################################
# 인스턴스에 부여할 역할
# #############################################################################
resource "aws_iam_role" "node_role_asg" {
  name = "${var.tag_header}node-role-asg"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole" # 신뢰 관계 허용 (임시 접근 권한)
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "node_policies_asg" {
  for_each   = var.ec2_policy_arns
  role       = aws_iam_role.node_role_asg.name
  policy_arn = each.value

}

# 인스턴스 프로필 생성
resource "aws_iam_instance_profile" "node_profile_asg" {
  name = "${var.tag_header}ASGNodeInstance-profile"
  role = aws_iam_role.node_role_asg.name
}


# ================================================================================
# CodeDeploy 역할(Role)
# --------------------------------------------------------------------------------
# 역할 생성
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.tag_header}AmazonCodeDeployService-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codedeploy.amazonaws.com" }
      Action    = "sts:AssumeRole" # IAM Role을 임시로 획득하여 권한을 행사할 수 있도록 허용
    }]
  })
}

# 관리형 정책을 역할에 연결
resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
