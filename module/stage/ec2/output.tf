output "ec2_public_az1" {
  value = aws_instance.ec2_pub_az1.id
}
output "ec2_public_az2" {
  value = aws_instance.ec2_pub_az2.id
}
output "public_ec2_instance_ids" {
  value = [
    aws_instance.ec2_pub_az1.id,
    aws_instance.ec2_pub_az2.id
  ]
}
