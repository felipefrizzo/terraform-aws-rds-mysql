locals {
  db_identifier_prefix      = "${var.service_name}-mysql"
  final_snapshot_identifier = "${local.db_identifier_prefix}-final-snapshot"

  # Change default values for read replica instance
  is_read_replica = var.replicate_source_db == "" ? false : true
  username        = local.is_read_replica ? "" : var.username
  password        = local.is_read_replica ? "" : (var.snapshot_identifier == "" ? random_id.password.hex : "")

  backup_retention_period = local.is_read_replica ? 0 : var.backup_retention_period
  skip_final_snapshot     = local.is_read_replica ? true : var.skip_final_snapshot
  copy_tags_to_snapshot   = local.is_read_replica ? false : var.copy_tags_to_snapshot
}

resource "random_id" "password" {
  byte_length = 8
}

#
# RDS DB Instance
resource "aws_db_instance" "mysql" {
  # Ignore changes on username as it is expected to be changed outside of Terraform or when restoring from snapshot
  # Ignore changes on password as it is expected to be changed outside of Terraform
  # Ignore changes on snapshot_identifier as it is expected to use this one time only when restoring from snapshot

  lifecycle {
    ignore_changes = [
      username,
      password,
      snapshot_identifier
    ]
  }

  count      = var.instance_count
  identifier = "${local.db_identifier_prefix}-${count.index}"

  # Indicates that this instance is a read replica
  replicate_source_db = var.replicate_source_db

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class
  username       = local.username
  password       = local.password
  port           = var.port

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  iops              = var.iops
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  db_subnet_group_name = var.db_subnet_group_name
  parameter_group_name = var.parameter_group_name

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  backup_retention_period = local.backup_retention_period
  backup_window           = var.backup_window

  skip_final_snapshot       = local.skip_final_snapshot
  final_snapshot_identifier = local.final_snapshot_identifier
  copy_tags_to_snapshot     = local.copy_tags_to_snapshot
  snapshot_identifier       = var.snapshot_identifier

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.enhanced_monitoring_arn

  tags = {
    Name          = "${local.db_identifier_prefix}-${count.index}"
    Service       = var.service_name
    ProductDomain = var.product_domain
    Environment   = var.environment
    Description   = var.description
    ManagedBy     = "Terraform"
  }
}

#
# CloudWatch resources
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "Alarm-${var.environment}-DatabaseServerCPUUtilization-${local.db_identifier_prefix}-${count.index}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold

  dimensions { DBInstanceIdentifier = aws_db_instance.mysql.*.id }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  alarm_name          = "Alarm-${var.environment}-DatabaseServerDiskQueueDepth-${local.db_identifier_prefix}-${count.index}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_disk_queue_threshold

  dimensions { DBInstanceIdentifier = aws_db_instance.mysql.*.id }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  alarm_name          = "Alarm-${var.environment}-DatabaseServerFreeStorageSpace-${local.db_identifier_prefix}-${count.index}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_disk_threshold

  dimensions { DBInstanceIdentifier = aws_db_instance.mysql.*.id }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  alarm_name          = "Alarm-${var.environment}-DatabaseServerFreeableMemory-${local.db_identifier_prefix}-${count.index}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_memory_threshold

  dimensions { DBInstanceIdentifier = aws_db_instance.mysql.*.id }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_credits" {
  // This results in 1 if instance_class starts with "db.t", 0 otherwise.
  count               = substr(var.instance_class, 0, 3) == "db.t" ? 1 : 0
  alarm_name          = "Alarm-${var.environment}-DatabaseCPUCreditBalance-${local.db_identifier_prefix}-${count.index}"
  alarm_description   = "Database CPU credit balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_cpu_credit_balance_threshold

  dimensions { DBInstanceIdentifier = aws_db_instance.mysql.*.id }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}
