output "vpc_id" {
  value = aws_vpc.this.id
}
output "private_subnet_ids" {
  value = [for s in aws_subnet.std11_private_subnet : s.id]
}
output "alb_sg_id" {
  value = aws_security_group.external_alb_sg.id
}
output "ssh_sg_id" {
  value = aws_security_group.ssh_sg.id
}
output "security_group_ids" {
  value = [
    aws_security_group.external_alb_sg.id,
    aws_security_group.ssh_sg.id,
  ]
}
