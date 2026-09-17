output "vpc_id" {
  value = aws_vpc.this.id
}
output "private_subnet_ids" {
  value = [for s in aws_subnet.std11_private_subnet : s.id]
}
