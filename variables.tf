variable "instance_count" {
  description = "The number of identical resources to create."
  type        = number
  default     = 1
}

variable "service_name" {
  description = "The name of the service this RDS belongs to, this will be part of the database identifier"
  type        = string
}

variable "product_domain" {
  description = "The name of the product domain this RDS belongs to"
  type        = string
}

variable "environment" {
  description = "The environment this RDS belongs to"
  type        = string
  default     = "dev"
}

variable "description" {
  description = "The description of this RDS instance"
  type        = string
}

variable "replicate_source_db" {
  description = "The source db of read replica instance"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "The mysql engine version"
  type        = string
  default     = "5.7"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes. For read replica, set the same value as master's"
  type        = string
}
variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"
  type        = string
  default     = "gp2"
}
variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1"
  type        = number
  default     = 0
}
variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}
variable "kms_key_id" {
  description = "Specifies a custom KMS key to be used to encrypt"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group"
  type        = string
  default     = ""
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
}

variable "availability_zone" {
  description = "The AZ for the RDS instance. It is recommended to only use this when creating a read replica instance"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Specifies if the RDS instance is public to outside access"
  type        = bool
  default     = false
}


variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'"
  type        = string
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Before and not overlap with maintenance_window"
  type        = string
  default     = ""
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = true
}

variable "snapshot_identifier" {
  description = "The snapshot ID used to restore the DB instance"
  type        = string
  default     = ""
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
  default     = 60
}

variable "enhanced_monitoring_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
}

variable "alarm_cpu_threshold" {
  description = "Database server CPU utilization alarm"
  type        = number
  default     = 75
}

variable "alarm_disk_queue_threshold" {
  description = "Database server disk queue depth"
  type        = number
  default     = 10
}

variable "alarm_free_disk_threshold" {
  description = "Database server free storage space"
  type        = number
  # 5GB
  default = 5000000000
}

variable "alarm_free_memory_threshold" {
  description = "Database server freeable memory"
  type        = number
  # 128MB
  default = 128000000
}

variable "alarm_cpu_credit_balance_threshold" {
  description = "Database CPU credit balance"
  type        = number
  default     = 30
}

variable alarm_actions {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state."
  type        = list(string)
}
variable ok_actions {
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state."
  type        = list(string)
}
variable insufficient_data_actions {
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state."
  type        = list(string)
}