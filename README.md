## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appstream_directory_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_directory_config) | resource |
| [aws_appstream_fleet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet) | resource |
| [aws_appstream_fleet_stack_association.association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet_stack_association) | resource |
| [aws_appstream_stack.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_stack) | resource |
| [aws_cloudwatch_metric_alarm.scale_down_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.scale_up_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.appstream_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.appstream_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.appstream_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_vpc_endpoint.appstream_vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_desired_instances"></a> [desired\_instances](#input\_desired\_instances) | Initial desired number of fleet instances | `number` | `1` | no |
| <a name="input_directory_name"></a> [directory\_name](#input\_directory\_name) | Active Directory name (optional) | `string` | `null` | no |
| <a name="input_disconnect_timeout_in_seconds"></a> [disconnect\_timeout\_in\_seconds](#input\_disconnect\_timeout\_in\_seconds) | Disconnect timeout | `number` | `300` | no |
| <a name="input_enable_default_internet_access"></a> [enable\_default\_internet\_access](#input\_enable\_default\_internet\_access) | Enable default internet access for fleet instances | `bool` | `false` | no |
| <a name="input_enable_scaling"></a> [enable\_scaling](#input\_enable\_scaling) | Enable or disable auto-scaling policies | `bool` | `true` | no |
| <a name="input_enable_vpce"></a> [enable\_vpce](#input\_enable\_vpce) | Enable VPC endpoint for AppStream streaming | `bool` | `false` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Number of CloudWatch periods to evaluate | `number` | `5` | no |
| <a name="input_fleet_type"></a> [fleet\_type](#input\_fleet\_type) | Fleet type: ON\_DEMAND or ALWAYS\_ON | `string` | `"ON_DEMAND"` | no |
| <a name="input_idle_disconnect_timeout_in_seconds"></a> [idle\_disconnect\_timeout\_in\_seconds](#input\_idle\_disconnect\_timeout\_in\_seconds) | Idle disconnect timeout | `number` | `600` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | AppStream image name | `string` | `"AppStream-WinServer2022-11-10-2025"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AppStream instance type | `string` | `"stream.standard.medium"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum fleet capacity | `number` | `3` | no |
| <a name="input_max_user_duration_in_seconds"></a> [max\_user\_duration\_in\_seconds](#input\_max\_user\_duration\_in\_seconds) | Maximum user session duration | `number` | `600` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum fleet capacity | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name used for AppStream stack, fleet, and IAM resources | `string` | n/a | yes |
| <a name="input_ou"></a> [ou](#input\_ou) | Organizational Unit DN (optional) | `string` | `null` | no |
| <a name="input_period"></a> [period](#input\_period) | CloudWatch alarm period in seconds | `number` | `300` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-west-2"` | no |
| <a name="input_scale_down_adjustment"></a> [scale\_down\_adjustment](#input\_scale\_down\_adjustment) | Number of instances to remove when scaling down | `number` | `2` | no |
| <a name="input_scale_up_adjustment"></a> [scale\_up\_adjustment](#input\_scale\_up\_adjustment) | Number of instances to add when scaling up | `number` | `2` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs for AppStream fleet and VPC endpoint | `list(string)` | n/a | yes |
| <a name="input_stream_view"></a> [stream\_view](#input\_stream\_view) | Stream view: DESKTOP or APPS | `string` | `"DESKTOP"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for AppStream fleet and VPC endpoint | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources | `map(string)` | `{}` | no |
| <a name="input_threshold_down"></a> [threshold\_down](#input\_threshold\_down) | Scale-down threshold (CapacityUtilization %) | `number` | `30` | no |
| <a name="input_threshold_up"></a> [threshold\_up](#input\_threshold\_up) | Scale-up threshold (CapacityUtilization %) | `number` | `50` | no |
| <a name="input_user_settings"></a> [user\_settings](#input\_user\_settings) | User settings for the AppStream stack | <pre>list(object({<br/>    action     = string<br/>    permission = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "action": "CLIPBOARD_COPY_FROM_LOCAL_DEVICE",<br/>    "permission": "ENABLED"<br/>  },<br/>  {<br/>    "action": "CLIPBOARD_COPY_TO_LOCAL_DEVICE",<br/>    "permission": "ENABLED"<br/>  },<br/>  {<br/>    "action": "FILE_UPLOAD",<br/>    "permission": "ENABLED"<br/>  },<br/>  {<br/>    "action": "FILE_DOWNLOAD",<br/>    "permission": "ENABLED"<br/>  },<br/>  {<br/>    "action": "PRINTING_TO_LOCAL_DEVICE",<br/>    "permission": "ENABLED"<br/>  },<br/>  {<br/>    "action": "DOMAIN_PASSWORD_SIGNIN",<br/>    "permission": "DISABLED"<br/>  },<br/>  {<br/>    "action": "DOMAIN_SMART_CARD_SIGNIN",<br/>    "permission": "DISABLED"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID (required if enable\_vpce = true) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fleet_name"></a> [fleet\_name](#output\_fleet\_name) | The name of the AppStream 2.0 fleet |
| <a name="output_stack_arn"></a> [stack\_arn](#output\_stack\_arn) | stack ARN |
| <a name="output_stack_name"></a> [stack\_name](#output\_stack\_name) | The name of the AppStream 2.0 stack |
