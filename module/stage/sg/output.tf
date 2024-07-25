output "sg_vpc_http_ssh" {
  value = aws_security_group.sg_vpc_http_ssh.id
}
output "sg_ssh" {
  value = aws_security_group.sg_vpc_ssh.id
}
output "sg_rds" {
  value = aws_security_group.rds_sg.id
}