resource "aws_eks_cluster" "std11_eks_cluster" {
  name     = "${var.tag_header}eks-cluster"
  role_arn = aws_iam_role.std11_eks_master_role.arn
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.std11_eks_master_policy_attachment]
  tags = {
    Name = "${var.tag_header}eks-cluster"
  }
  lifecycle {
    ignore_changes = [version]
  }
}

# 클러스터 SG에 "노드 SG에서 443 허용". LT에 커스텀 SG만 있으면 컨트롤플레인이 워커를 모름
resource "aws_security_group_rule" "std11_eks_cluster_from_nodes" {
  type                     = "ingress"
  description              = "Allow worker nodes to cluster API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.std11_eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.std11_eks_sg.id
}
