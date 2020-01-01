output "address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.mysql.*.address
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.mysql.*.arn
}

output "endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.mysql.*.endpoint
}

output "hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.mysql.*.hosted_zone_id
}

output "id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.mysql.*.id
}

output "resource_id" {
  description = "The RDS Resource ID of mysql instance"
  value       = aws_db_instance.mysql.*.resource_id
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_db_instance.mysql.*.availability_zone
}

output "password" {
  description = "The password for the DB"
  value       = local.password
}