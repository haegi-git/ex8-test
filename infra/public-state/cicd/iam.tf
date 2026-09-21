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
