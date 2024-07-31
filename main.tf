provider "aws" {
  region = "us-west-2"
}

### IAM
resource "aws_iam_role" "appstream_role" {
  name = join("-", [var.name, "role"])

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

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Effect = "Allow",
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "appstream_role_attachment" {
  role       = aws_iam_role.appstream_role.name
  policy_arn = aws_iam_policy.appstream_policy.arn
}



# Conditionally Create VPC Endpoint
resource "aws_vpc_endpoint" "appstream_vpce" {
  count             = var.enable_vpce ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.appstream.streaming"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.security_group_ids

  tags = var.tags
}

resource "aws_appstream_stack" "this" {
  name         = join("-", [var.name, "stack"])
  display_name = join("-", [var.name, "stack"])
  description  = join("-", [var.name, "stack"])
  storage_connectors {
    connector_type = "HOMEFOLDERS"
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
  name                           = join("-", [var.name, "fleet"])
  instance_type                  = var.instance_type
  fleet_type                     = var.fleet_type
  image_name                     = var.image_name
  max_user_duration_in_seconds   = var.max_user_duration_in_seconds
  disconnect_timeout_in_seconds  = var.disconnect_timeout_in_seconds
  idle_disconnect_timeout_in_seconds = var.idle_disconnect_timeout_in_seconds
  #min_capacity      = var.min_capacity  # Set the minimum fleet size
  #max_capacity      = var.max_capacity  # Set the maximum fleet size
  stream_view                    = var.stream_view
  enable_default_internet_access = var.enable_default_internet_access
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  iam_role_arn = aws_iam_role.appstream_role.arn

  compute_capacity {
    desired_instances = var.desired_instances
  }
  domain_join_info {
    directory_name = var.directory_name
    organizational_unit_distinguished_name = var.ou
  }
  tags = var.tags
}

resource "aws_appstream_fleet_stack_association" "association" {
  fleet_name = aws_appstream_fleet.this.name
  stack_name = aws_appstream_stack.this.name
}


###
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "fleet/${aws_appstream_fleet.this.name}"
  scalable_dimension = "appstream:fleet:DesiredCapacity"
  service_namespace  = "appstream"
}

resource "aws_appautoscaling_policy" "scale_up" {
  count              = var.enable_scaling ? 1 : 0
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
      scaling_adjustment = var.scale_up_adjustment
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  count              = var.enable_scaling ? 1 : 0
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
      scaling_adjustment = var.scale_down_adjustment
      metric_interval_upper_bound = 0
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  count              = var.enable_scaling ? 1 : 0
  alarm_name         = "scale-up-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.threshold_up

  dimensions = {
    FleetName = aws_appstream_fleet.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_up[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  count              = var.enable_scaling ? 1 : 0
  alarm_name         = "scale-down-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.threshold_down

  dimensions = {
    FleetName = aws_appstream_fleet.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_down[0].arn]
}




