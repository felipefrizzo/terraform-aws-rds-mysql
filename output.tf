output "address" {
  description = "The address of the RDS instance"
  value       = "${aws_db_instance.postgresql.*.address}"
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = "${aws_db_instance.postgresql.*.arn}"
}

output "endpoint" {
  description = "The connection endpoint"
  value       = "${aws_db_instance.postgresql.*.endpoint}"
}

output "hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = "${aws_db_instance.postgresql.*.hosted_zone_id}"
}

output "id" {
  description = "The RDS instance ID"
  value       = "${aws_db_instance.postgresql.*.id}"
}

output "resource_id" {
  description = "The RDS Resource ID of postgresql instance"
  value       = "${aws_db_instance.postgresql.*.resource_id}"
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = "${aws_db_instance.postgresql.*.availability_zone}"
}

output "password" {
  description = "The password for the DB"
  value       = "${local.password}"
}