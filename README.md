# terraform-aws-rds-mysql

Terraform module to create an AWS RDS (Relational Database Server) MySQL.

## Requirements
* An existing VPC.
* An existing DB Subnet Group.
* An existing Parameter Group for MySQL.
* An existing RDS Enhanced Monitoring role.

### Password for Master Database
* The module will generate a random 16 characteres long password.

### Read Replica Database
If replicate_source_db parameter is defined, it indicates that the instance is meant to be a read replica.

These parameters will be inherited from the master's in the first creation stage:

1. allocated_storage
2. maintenance_window
3. parameter_group_name
3. vpc_security_group_ids

To apply different values for the parameters above, you have to re-apply the configuration after the first creation is finished.

## Usage
```
module "mysql" {
  source = "git::https://github.com/felipefrizzo/terraform-aws-rds-mysql?ref=master"

  product_domain = "frizzo"
  service_name   = "rds-master-frizzo"
  environment    = "production"
  description    = "Mysql server to store Github data"

  instance_class = "db.t2.medium"

  allocated_storage = 100

  # Change to valid security group id
  vpc_security_group_ids = [
    "sg-00000000"
  ]

  # Change to valid db subnet group name
  db_subnet_group_name = "rds-subnet-group"

  # Change to valid parameter group name
  parameter_group_name = "default.mysql5.7"

  maintenance_window      = "Sun:02:00-Sun:03:00"
  backup_window           = "00:00-01:00"
  backup_retention_period = 10

  # Change to valid monitoring role arn
  monitoring_role_arn = "arn:aws:iam::000000000000:role/rds-monitoring-role"
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| instance_count | The number of identical resources to create | string | - | yes |
| service_name | The name of the service this RDS belongs to, this will be part of the database identifier | string | - | yes |
| product_domain | The name of the product domain this RDS belongs to | string | - | yes |
| environment | The environment this RDS belongs to | string | `dev` | no |
| description | The description of this RDS instance | string | - | yes |
| replicate_source_db | The source db of read replica instance | string | `` | no |
| engine_version | The mysql engine version | string | `5.7` | no |
| instance_class | The instance type of the RDS instance | string | - | yes |
| username | Username for the master DB user | string | `root` | no |
| port | The port on which the DB accepts connections | string | `3306` | no |
| allocated_storage | The allocated storage in gigabytes. For read replica, set the same value as master's | string | - | yes |
| storage_type | One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD) | string | `gp` | no |
| iops | The amount of provisioned IOPS. Setting this implies a storage_type of io1  | string | `0` | no |
| storage_encrypted | Specifies whether the DB instance is encrypted | string | `true` | no |
| kms_key_id | Specifies a custom KMS key to be used to encrypt | string | `` | no |
| vpc_security_group_ids | List of VPC security groups to associate | list | `<list>` | yes |
| db_subnet_group_name | Name of DB subnet group | string | `` | no |
| parameter_group_name | Name of the DB parameter group to associate | string | - | yes |
| availability_zone | The AZ for the RDS instance. It is recommended to only use this when creating a read replica instance | string | `` | no |
| multi_az | Specifies if the RDS instance is multi-AZ | string | `true` | no |
| publicly_accessible | Specifies if the RDS instance is public to outside access | string | `false` | no |
| allow_major_version_upgrade | Indicates that major version upgrades are allowed | string | `false` | no |
| auto_minor_version_upgrade | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | string | `false` | no |
| apply_immediately | Specifies whether any database modifications are applied immediately, or during the next maintenance window | string | `false` | no |
| maintenance_window | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' | string | - | yes |
| backup_retention_period | The days to retain backups for | int | 7 | no |
| backup_window | The daily time range (in UTC) during which automated backups are created if they are enabled. Before and not overlap with maintenance_window | string | `` | no |
| skip_final_snapshot | Determines whether a final DB snapshot is created before the DB instance is deleted | string | `false` | no |
| copy_tags_to_snapshot | On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified) | string | `true` | no |
| snapshot_identifier | The snapshot ID used to restore the DB instance | string | `` | no |
| monitoring_interval | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance | string | `60` | no |
| enhanced_monitoring_arn | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs | string | - | yes |
| alarm_cpu_threshold | Database server CPU utilization alarm | string | `75` | no |
| alarm_disk_queue_threshold | Database server disk queue depth | string | `10` | no |
| alarm_free_disk_threshold | Database server free storage space (5GB) | string | `5000000000` | no |
| alarm_free_memory_threshold | Database server freeable memory (128MB) | string | `128000000` | no |
| alarm_cpu_credit_balance_threshold | Database CPU credit balance | string | `30` | no |
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. | list | `<list>` | yes |
| ok_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. | list | `<list>` | yes |
| insufficient_data_actions | The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state. | list | `<list>` | yes |
