module "vpc" {
  source      = "./module/stage/vpc"
  vpc_cidr    = "10.0.0.0/16"
  nat-gateway = module.nat_gateway.NAT-gw-id
}
module "nat_gateway" {
  source = "./module/stage/nat"
  public_subnet = module.vpc.private_subnet
}
module "sg" {
  source = "./module/stage/sg"
  vpc_id = module.vpc.vpc_id
}
# module "ec2" {
#   source   = "./module/stage/ec2"
#   vpc_id         = module.vpc.vpc_id
#   ec2_type       = "t2.micro"
#   key            = "us-east-1-key"
#   ec2_ami        = "ami-04a81a99f5ec58529"
#   sg_vpc_http_ssh= module.sg.sg_vpc_http_ssh
#   sg_vpc_ssh     = module.sg.sg_ssh
#   public_subnet  = module.vpc.public_subnet
#   private_subnet = module.vpc.private_subnet
# }
module "alb" { 
  source = "./module/stage/alb"
  vpc_id           = module.vpc.vpc_id
  # ec2_public_az1   = module.ec2.ec2_public_az1
  # ec2_public_az2   = module.ec2.ec2_public_az2 
  sg_http_ssh      = module.sg.sg_vpc_http_ssh
  sg_ssh           = module.sg.sg_ssh
  public_subnet    = module.vpc.public_subnet_ids
  # ec2_instance_ids = module.ec2.public_ec2_instance_ids 
  public-asg-id    = module.asg.public_asg
}
module "rds" {
  source = "./module/stage/rds"
  sg_for_rds       = module.sg.sg_rds
  subnet-group     = module.vpc.subnet_group_for_db
}
module "asg" {
  source = "./module/stage/asg"
  ami_id             = "ami-04a81a99f5ec58529"
  instance_type      = "t2.micro"
  key                = "us-east-1-key"
  sg_vpc_http_ssh    = module.sg.sg_vpc_http_ssh
  public_subnets     = module.vpc.public_subnet_ids
  private_subnets    = module.vpc.private_subnet_ids 
}
