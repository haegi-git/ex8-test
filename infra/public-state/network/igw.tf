# ------------------------------------------------------------
# 인터넷 게이트웨이 (IGW)
# VPC와 인터넷을 잇는 문. 퍼블릭 서브넷이 인터넷 쓰려면 이게 필요함
# ------------------------------------------------------------
resource "aws_internet_gateway" "std11_igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.tag_header}igw"
  }
}

# ------------------------------------------------------------
# NAT에 붙일 고정 공인 IP (EIP)
# NAT Gateway는 반드시 EIP가 있어야 함
# ------------------------------------------------------------
resource "aws_eip" "std11_nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.tag_header}nat-eip"
  }
}

# ------------------------------------------------------------
# NAT 게이트웨이
# 프라이빗 서브넷이 "나갈 때만" 인터넷 쓰게 해 줌 (업데이트, 이미지 pull)
# 퍼블릭 서브넷에 있어야 함. IGW보다 먼저 만들면 실패할 수 있음
# ------------------------------------------------------------
resource "aws_nat_gateway" "std11_nat_gw" {
  allocation_id = aws_eip.std11_nat_eip.id
  subnet_id     = aws_subnet.std11_public_subnet["eu-central-1a"].id
  tags = {
    Name = "${var.tag_header}nat-gw"
  }
  depends_on = [aws_internet_gateway.std11_igw]
}

# ------------------------------------------------------------
# 퍼블릭 라우트 테이블 + 기본 라우트
# 0.0.0.0/0 = 그 외 모든 목적지 → IGW로 보내라
# 이 한 줄이 있어야 퍼블릭 서브넷이 진짜 퍼블릭이 됨
# ------------------------------------------------------------
resource "aws_route_table" "std11_public_rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.tag_header}public-rt"
  }
}

resource "aws_route" "std11_public_internet" {
  route_table_id         = aws_route_table.std11_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.std11_igw.id
}

# 퍼블릭 서브넷 전부 이 테이블에 연결
resource "aws_route_table_association" "std11_public_rt_assoc" {
  for_each       = aws_subnet.std11_public_subnet
  route_table_id = aws_route_table.std11_public_rt.id
  subnet_id      = each.value.id
}

# ------------------------------------------------------------
# 프라이빗 라우트 테이블 (AZ마다 1개)
# 나가는 인터넷만 NAT으로. 밖에서 직접 들어오진 못함
# ------------------------------------------------------------
resource "aws_route_table" "std11_private_rt" {
  for_each = aws_subnet.std11_private_subnet
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.tag_header}private-${split("-", each.key)[length(split("-", each.key)) - 1]}-rt"
  }
}

resource "aws_route" "std11_private_nat" {
  for_each               = aws_subnet.std11_private_subnet
  route_table_id         = aws_route_table.std11_private_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.std11_nat_gw.id
}

resource "aws_route_table_association" "std11_private_rt_assoc" {
  for_each       = aws_subnet.std11_private_subnet
  route_table_id = aws_route_table.std11_private_rt[each.key].id
  subnet_id      = each.value.id
}
