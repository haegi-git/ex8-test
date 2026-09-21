# 외부 ALB / 웹. 인터넷 → 80, 443
resource "aws_security_group" "external_alb_sg" {
  name        = "${var.tag_header}external-alb-sg"
  description = "Allow HTTP and HTTPS Traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.tag_header}external-alb-sg" }
}

# SSH
resource "aws_security_group" "ssh_sg" {
  name        = "${var.tag_header}ssh-sg"
  description = "Allow SSH Traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.tag_header}ssh-sg" }
}
