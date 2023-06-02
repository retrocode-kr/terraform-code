
data "aws_partition" "current" {}
locals {
  project_name_and_env_name    = var.project_name != null ? "${var.project_name}-${var.env_name}" : "${var.env_name}"
  rds_parameter_group_name     = try(coalesce(var.rds_parameter_group_name, var.name), null)
  cluster_parameter_group_name = try(coalesce(var.db_cluster_parameter_group_name, var.name), null)
  db_parameter_group_name      = try(coalesce(var.db_parameter_group_name, var.name), null)
}

resource "aws_security_group" "rds" {
  name = "${local.project_name_and_env_name}-DB-SG"
  #name  = "${var.name}-SG"
  vpc_id = var.vpc_id
  #tags   = { Name = "${local.project_name_and_env_name}-DB-SG" }
  tags = { Name = "${var.name}-SG" }
}

resource "aws_db_instance" "rds" {
  #count                       = local.create_rds ? length(var.identifier) : 0
  count                       = var.rds_type == "rds" ? 1 : 0
  identifier                  = lower(var.rds_identifier)
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  license_model               = var.license_model
  port                        = var.port
  instance_class              = var.instance_class
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  # multi_az                            = var.multi_az
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  skip_final_snapshot = var.skip_final_snapshot
  # parameter_group           = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : var.db_parameter_group_name
  parameter_group_name                = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : var.db_parameter_group_name
  backup_window                       = var.backup_window
  vpc_security_group_ids              = [aws_security_group.rds.id]
  backup_retention_period             = var.backup_retention_period
  db_subnet_group_name                = var.database_subnet_group_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  tags = merge(
  var.db_add_tags)
}

resource "aws_rds_cluster" "aurora" {
  count               = var.rds_type == "aurora" ? 1 : 0
  cluster_identifier  = lower(var.name)
  availability_zones  = var.availability_zones
  engine              = var.engine
  engine_version      = var.engine_version
  database_name       = var.db_name
  master_username     = var.username
  master_password     = var.password
  skip_final_snapshot = var.skip_final_snapshot
  apply_immediately   = true
  #db_subnet_group_name = data.terraform_remote_state.vpc.outputs.database_subnet_group_name
  db_subnet_group_name                = var.database_subnet_group_name
  backup_retention_period             = var.backup_retention_period
  preferred_maintenance_window        = var.preferred_maintenance_window
  preferred_backup_window             = var.backup_window
  db_cluster_parameter_group_name     = var.create_db_cluster_parameter_group ? aws_rds_cluster_parameter_group.this[0].id : var.db_cluster_parameter_group_name
  vpc_security_group_ids              = [aws_security_group.rds.id]
  allow_major_version_upgrade         = var.auto_minor_version_upgrade
  enable_global_write_forwarding      = var.enable_global_write_forwarding
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  deletion_protection                 = var.deletion_protection
  # 기본적으로 aurora는 zone  3개인데 3개보다 낮게 지정하면 코드 수정시 매번 지웠다 다시 만들어야 한다.
  # 그렇기에 lifecycle블록에 ignore_change를 추가해야 한다 

  lifecycle {
    ignore_changes = [availability_zones]

  }
  tags = merge(
  var.db_add_tags)
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  for_each                     = { for k, v in var.instances : k => v if var.rds_type == "aurora" }
  identifier                   = var.instances_use_identifier_prefix ? null : try(each.value.identifier, "${lower(var.name)}-${each.key}")
  identifier_prefix            = var.instances_use_identifier_prefix ? try(each.value.identifier_prefix, "${lower(var.name)}-${each.key}-") : null
  availability_zone            = try(each.value.availability_zone, null)
  cluster_identifier           = aws_rds_cluster.aurora[0].id
  db_parameter_group_name      = var.create_db_parameter_group ? aws_db_parameter_group.this[0].id : var.db_parameter_group_name
  instance_class               = try(each.value.instance_class, var.instance_class)
  engine                       = var.engine
  engine_version               = var.engine_version
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  monitoring_interval          = try(each.value.monitoring_interval, var.monitoring_interval)
  preferred_maintenance_window = try(each.value.preferred_maintenance_window, var.preferred_maintenance_window)
  promotion_tier               = try(each.value.promotion_tier, null)
  publicly_accessible          = try(each.value.publicly_accessible, var.publicly_accessible)
}

resource "aws_rds_cluster_endpoint" "this" {
  for_each = { for k, v in var.endpoints : k => v if var.rds_type == "aurora" }

  cluster_endpoint_identifier = each.value.identifier
  cluster_identifier          = aws_rds_cluster.aurora[0].id
  custom_endpoint_type        = each.value.type
  excluded_members            = try(each.value.excluded_members, null)
  static_members              = try(each.value.static_members, null)
  tags                        = merge(var.db_add_tags, try(each.value.tags, {}))

  depends_on = [
    aws_rds_cluster_instance.cluster_instances
  ]
}


################################################################################
# Cluster Parameter Group
################################################################################



resource "aws_rds_cluster_parameter_group" "this" {
  count = var.create_db_cluster_parameter_group ? 1 : 0

  name        = var.db_cluster_parameter_group_use_name_prefix ? null : local.cluster_parameter_group_name
  name_prefix = var.db_cluster_parameter_group_use_name_prefix ? "${local.cluster_parameter_group_name}-" : null
  description = var.db_cluster_parameter_group_description
  family      = var.db_cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.db_cluster_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.db_add_tags
}
################################################################################
# DB Parameter Group
################################################################################
resource "aws_db_parameter_group" "this" {
  count       = var.create_db_parameter_group ? 1 : 0
  name        = var.db_parameter_group_name
  family      = var.db_parameter_group_family
  description = var.db_parameter_group_description

  dynamic "parameter" {
    for_each = var.db_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.db_add_tags
}


resource "aws_rds_cluster_role_association" "this" {
  for_each = { for k, v in var.iam_roles : k => v }

  db_cluster_identifier = aws_rds_cluster.aurora[0].id
  feature_name          = each.value.feature_name
  role_arn              = each.value.role_arn
}


data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : var.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${var.iam_role_name}-" : null
  description = var.iam_role_description
  path        = var.iam_role_path

  assume_role_policy    = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  managed_policy_arns   = var.iam_role_managed_policy_arns
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration

  tags = var.db_add_tags
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0

  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"

}
