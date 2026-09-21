locals {
  azs = slice(data.aws_availability_zones.available_az.names, 0, 3)
  tag_header = (var.owner != "" && var.environment != "") ? "${var.owner}-${var.environment}-" : (
    (var.owner != "") ? "${var.owner}-" : ""
  )
  ami_id = data.aws_ami.al2023.id

  ec2_policy_arns = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
}


locals {
  node_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    # ECR 레포지토리 이미지 읽기
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    # SSM: SSH 없이 터미널 접속 가능
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    # Logging: 파드 및 시스템 로그 전송
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    # S3: 설정 파일이나 이미지 읽기 (필요 시 수정)
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}
