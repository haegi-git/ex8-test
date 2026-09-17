resource "aws_iam_role" "std11_eks_master_role" {
  name = "${var.tag_header}eks-master-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "std11_eks_master_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.std11_eks_master_role.id
}

resource "aws_iam_role" "std11_eks_node_role" {
  name = "${var.tag_header}eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "std11_eks_node_policy_attachment" {
  for_each   = toset(var.node_policies)
  policy_arn = each.value
  role       = aws_iam_role.std11_eks_node_role.id
}
