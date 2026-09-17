resource "aws_subnet" "std11_public_subnet" {
  for_each                                    = toset(var.azs)
  vpc_id                                      = aws_vpc.this.id
  cidr_block                                  = var.subnet_cidr[0][each.key]
  availability_zone                           = each.key
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "${var.tag_header}public${split("-", each.key)[length(split("-", each.key)) - 1]}-subnet"
  }
}

resource "aws_subnet" "std11_private_subnet" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr[1][each.key]
  availability_zone = each.key
  tags = {
    Name = "${var.tag_header}private${split("-", each.key)[length(split("-", each.key)) - 1]}-subnet"
  }
}
