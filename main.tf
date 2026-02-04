provider "aws" {
  region = var.region
}

### IAM
resource "aws_iam_role" "appstream_role" {
  name        = join("-", [var.name, "role"])
  description = "Role to define allowed actions for AppStream streaming instances (analogous to Instance Host Roles for EC2)"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "appstream.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_policy" "appstream_policy" {
  name        = join("-", [var.name, "policy"])
  description = "Managed By Terraform"

  policy = var.appstream_machine_policy
}

resource "aws_iam_role_policy_attachment" "appstream_role_attachment" {
  role       = aws_iam_role.appstream_role.name
  policy_arn = aws_iam_policy.appstream_policy.arn
}

# Conditionally Create VPC Endpoint
resource "aws_vpc_endpoint" "appstream_vpce" {
  count              = var.enable_vpce ? 1 : 0
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.appstream.streaming"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  tags = var.tags
}

# Optional: Domain join using non-managed AD and Secrets Manager
resource "aws_appstream_directory_config" "this" {
  count = var.directory_name != "" && var.secretsmanager_name != "" ? 1 : 0

  directory_name = var.directory_name
  organizational_unit_distinguished_names = [
    var.ou
  ]

  service_account_credentials {
    account_name     = jsondecode(data.aws_secretsmanager_secret_version.this[0].secret_string)["username"]
    account_password = jsondecode(data.aws_secretsmanager_secret_version.this[0].secret_string)["password"]
  }
}


# Secrets Manager data source for service account
data "aws_secretsmanager_secret" "this" {
  count = var.secretsmanager_name != "" ? 1 : 0
  name  = var.secretsmanager_name
}

data "aws_secretsmanager_secret_version" "this" {
  count     = var.secretsmanager_name != "" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.this[0].id
}



# Stack
resource "aws_appstream_stack" "this" {
  name         = join("-", [var.name, "stack"])
  display_name = join("-", [var.name, "stack"])
  description  = join("-", [var.name, "stack"])

  # Dynamic HOMEFOLDERS connector
  dynamic "storage_connectors" {
    for_each = var.enable_persistent_storage ? [1] : []
    content {
      connector_type = "HOMEFOLDERS"
    }
  }

  dynamic "user_settings" {
    for_each = var.user_settings
    content {
      action     = user_settings.value.action
      permission = user_settings.value.permission
    }
  }

  dynamic "access_endpoints" {
    for_each = var.enable_vpce ? [1] : []
    content {
      endpoint_type = "STREAMING"
      vpce_id       = aws_vpc_endpoint.appstream_vpce[0].id
    }
  }

  application_settings {
    enabled        = true
    settings_group = join("-", [var.name, "setting-group"])
  }

  tags = var.tags
}


### Fleet
resource "aws_appstream_fleet" "this" {
  name                               = join("-", [var.name, "fleet"])
  instance_type                      = var.instance_type
  fleet_type                         = var.fleet_type
  image_name                         = var.image_name
  max_user_duration_in_seconds       = var.max_user_duration_in_seconds
  disconnect_timeout_in_seconds      = var.disconnect_timeout_in_seconds
  idle_disconnect_timeout_in_seconds = var.idle_disconnect_timeout_in_seconds
  stream_view                        = var.stream_view
  enable_default_internet_access     = var.enable_default_internet_access
  iam_role_arn                       = aws_iam_role.appstream_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  compute_capacity {
    desired_instances = var.desired_instances
  }

  dynamic "domain_join_info" {
    for_each = aws_appstream_directory_config.this[*]  # will be empty if no domain join
    content {
      directory_name                         = domain_join_info.value.directory_name
      organizational_unit_distinguished_name = domain_join_info.value.organizational_unit_distinguished_names[0]
    }
  }

  lifecycle {
    ignore_changes = [compute_capacity, image_name]
  }

  tags = var.tags
}


resource "aws_appstream_fleet_stack_association" "association" {
  fleet_name = aws_appstream_fleet.this.name
  stack_name = aws_appstream_stack.this.name
}

# Auto Scaling
resource "aws_appautoscaling_target" "this" {
  depends_on = [aws_appstream_fleet.this]

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "fleet/${aws_appstream_fleet.this.name}"
  scalable_dimension = "appstream:fleet:DesiredCapacity"
  service_namespace  = "appstream"
}

resource "aws_appautoscaling_policy" "scale_up" {
  count = var.enable_scaling ? 1 : 0
  depends_on = [aws_appautoscaling_target.this]

  name               = "scale-up-policy"
  policy_type        = "StepScaling"
  resource_id        = "fleet/${aws_appstream_fleet.this.name}"
  scalable_dimension = "appstream:fleet:DesiredCapacity"
  service_namespace  = "appstream"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = var.scale_up_adjustment
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  count = var.enable_scaling ? 1 : 0
  depends_on = [aws_appautoscaling_target.this]

  name               = "scale-down-policy"
  policy_type        = "StepScaling"
  resource_id        = "fleet/${aws_appstream_fleet.this.name}"
  scalable_dimension = "appstream:fleet:DesiredCapacity"
  service_namespace  = "appstream"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = var.scale_down_adjustment
      metric_interval_upper_bound = 0
    }
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  count               = var.enable_scaling ? 1 : 0
  alarm_name          = "${var.name}-scale-up-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods_up != null ? var.evaluation_periods_up : var.evaluation_periods
  metric_name         = "CapacityUtilization"
  namespace           = "AWS/AppStream"
  period              = var.period_up != null ? var.period_up : var.period
  statistic           = "Average"
  threshold           = var.threshold_up

  dimensions = {
    Fleet = aws_appstream_fleet.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_up[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  count               = var.enable_scaling ? 1 : 0
  alarm_name          = "${var.name}-scale-down-Alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods_down != null ? var.evaluation_periods_down : var.evaluation_periods
  metric_name         = "CapacityUtilization"
  namespace           = "AWS/AppStream"
  period              = var.period_down != null ? var.period_down : var.period
  statistic           = "Average"
  threshold           = var.threshold_down

  dimensions = {
    Fleet = aws_appstream_fleet.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_down[0].arn]
}
