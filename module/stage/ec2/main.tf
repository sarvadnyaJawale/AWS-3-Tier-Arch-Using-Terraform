# I am not using this data because, we have to attach multiple subnets,right!
# data "aws_subnet" "public_subnet" {
#   filter {
#     name = "tag:Name"
#     values = ["Subnet-Public : Public Subnet 1"]
#   }

#   depends_on = [
#     aws_route_table_association.public_subnet_asso
#   ]
# }

resource "aws_instance" "ec2_pub_az1" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  associate_public_ip_address = true
  
  tags = {
    Name                 = "EC2 Public subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.sg_vpc_http_ssh]
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo apt update -y
                            sudo apt install nginx -y 
                            sudo systemctl enable nginx
                            sudo systemctl start nginx
                            EOF
}

resource "aws_instance" "ec2_pub_az2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  associate_public_ip_address = true
  tags = {
    Name                 = "EC2 public subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.public_subnet[1]
  vpc_security_group_ids = [var.sg_vpc_http_ssh]
  user_data              = <<-EOF
                          #!/bin/bash
                          sudo apt update -y
                          sudo apt install nginx -y 
                          sudo systemctl enable nginx
                          sudo systemctl start nginx
                          EOF
}

resource "aws_instance" "ec2_pri_az1" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  tags = {
    Name                 = "EC2 Private subnet in az1"
  }
  key_name               = var.key
  subnet_id              = var.private_subnet[0]
  vpc_security_group_ids = [var.sg_vpc_ssh]

}

resource "aws_instance" "ec2_pri_az2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  tags = {
    Name                 = "EC2 Private subnet in az2"
  }
  key_name               = var.key
  subnet_id              = var.private_subnet[1]
  vpc_security_group_ids = [var.sg_vpc_ssh]

}
