resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet[0]  # Assuming you want to create the NAT Gateway in the first public subnet

  tags = {
    Name = "NAT Gateway"
  }
}