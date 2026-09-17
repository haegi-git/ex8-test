data "aws_ami" "eks_al2023_latest" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS 공식 계정
  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-x86_64-standard-${aws_eks_cluster.std11_eks_cluster.version}-v*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_launch_template" "std11_eks_node_launch_template" {
  name_prefix   = "${var.tag_header}eks-node-launch-template-"
  image_id      = data.aws_ami.eks_al2023_latest.id
  instance_type = "t3.small"
  key_name      = "std11-central-key"
  vpc_security_group_ids = [
    aws_eks_cluster.std11_eks_cluster.vpc_config[0].cluster_security_group_id,
    aws_security_group.std11_eks_sg.id,
  ]
  update_default_version = true
  user_data = base64encode(<<-EOT
---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${aws_eks_cluster.std11_eks_cluster.name}
    apiServerEndpoint: ${aws_eks_cluster.std11_eks_cluster.endpoint}
    certificateAuthority: ${aws_eks_cluster.std11_eks_cluster.certificate_authority[0].data}
    cidr: ${aws_eks_cluster.std11_eks_cluster.kubernetes_network_config[0].service_ipv4_cidr}
EOT
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_header}eks-node-launch-template"
    }
  }
  tags = {
    Name = "${var.tag_header}eks-node-launch-template"
  }
}

resource "aws_eks_node_group" "std11_eks_node_group" {
  node_group_name = "${var.tag_header}eks-node-group"
  cluster_name    = aws_eks_cluster.std11_eks_cluster.name
  node_role_arn   = aws_iam_role.std11_eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  ami_type        = "CUSTOM"
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  launch_template {
    id      = aws_launch_template.std11_eks_node_launch_template.id
    version = aws_launch_template.std11_eks_node_launch_template.latest_version
  }
  depends_on = [aws_iam_role_policy_attachment.std11_eks_node_policy_attachment]
  tags = {
    Name = "${var.tag_header}eks-node-group"
  }
}
