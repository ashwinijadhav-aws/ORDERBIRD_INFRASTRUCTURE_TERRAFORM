
output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.EC2-Machine.*.id
}