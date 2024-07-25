output "public_asg" {
  value = aws_autoscaling_group.public_autoscale.id
}
output "private_asg" {
  value = aws_autoscaling_group.private_autoscale.id
}