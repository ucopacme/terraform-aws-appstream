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
| [aws_appstream_fleet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet) | resource |
| [aws_appstream_fleet_stack_association.association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet_stack_association) | resource |
| [aws_appstream_stack.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_stack) | resource |
| [aws_cloudwatch_metric_alarm.scale_down_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.scale_up_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.appstream_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.appstream_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.appstream_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_vpc_endpoint.appstream_vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_desired_instances"></a> [desired\_instances](#input\_desired\_instances) | Desired Instance Number | `number` | `1` | no |
| <a name="input_desired_sessions"></a> [desired\_sessions](#input\_desired\_sessions) | Desired Session | `number` | `null` | no |
| <a name="input_directory_name"></a> [directory\_name](#input\_directory\_name) | directory\_name | `string` | `null` | no |
| <a name="input_disconnect_timeout_in_seconds"></a> [disconnect\_timeout\_in\_seconds](#input\_disconnect\_timeout\_in\_seconds) | Disconnect TimeOut | `number` | `300` | no |
| <a name="input_enable_default_internet_access"></a> [enable\_default\_internet\_access](#input\_enable\_default\_internet\_access) | enable Internet access | `string` | `"false"` | no |
| <a name="input_enable_scaling"></a> [enable\_scaling](#input\_enable\_scaling) | Enable or disable auto-scaling policies | `bool` | `true` | no |
| <a name="input_enable_vpce"></a> [enable\_vpce](#input\_enable\_vpce) | Enable VPC endpoint for streaming | `bool` | `false` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | period | `number` | `5` | no |
| <a name="input_fleet_type"></a> [fleet\_type](#input\_fleet\_type) | Fleet Type ON-DEMOND OR ALWAYS-ON | `string` | `"ON_DEMAND"` | no |
| <a name="input_idle_disconnect_timeout_in_seconds"></a> [idle\_disconnect\_timeout\_in\_seconds](#input\_idle\_disconnect\_timeout\_in\_seconds) | Idle Timeout | `number` | `600` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Image Name | `string` | `"AppStream-WinServer2016-06-17-2024"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance Type | `string` | `"stream.standard.medium"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Max capacity | `number` | `3` | no |
| <a name="input_max_sessions_per_instance"></a> [max\_sessions\_per\_instance](#input\_max\_sessions\_per\_instance) | Max Sessions per instance | `number` | `null` | no |
| <a name="input_max_user_duration_in_seconds"></a> [max\_user\_duration\_in\_seconds](#input\_max\_user\_duration\_in\_seconds) | Max user Duration | `number` | `600` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Max capacity | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Appstream stack/fleet name | `string` | `""` | no |
| <a name="input_ou"></a> [ou](#input\_ou) | organizational\_unit\_distinguished\_name | `string` | `null` | no |
| <a name="input_period"></a> [period](#input\_period) | period | `number` | `300` | no |
| <a name="input_region"></a> [region](#input\_region) | aws region | `string` | `"us-west-2"` | no |
| <a name="input_scale_down_adjustment"></a> [scale\_down\_adjustment](#input\_scale\_down\_adjustment) | Number of instances to remove when scaling down. | `number` | `2` | no |
| <a name="input_scale_up_adjustment"></a> [scale\_up\_adjustment](#input\_scale\_up\_adjustment) | Number of instances to add when scaling up. | `number` | `2` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security Group ID | `list(string)` | `[]` | no |
| <a name="input_stream_view"></a> [stream\_view](#input\_stream\_view) | Stream View DESKTOP or APPS | `string` | `"DESKTOP"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_threshold_down"></a> [threshold\_down](#input\_threshold\_down) | scale\_down | `number` | `30` | no |
| <a name="input_threshold_up"></a> [threshold\_up](#input\_threshold\_up) | scale\_up | `number` | `50` | no |
| <a name="input_user_settings"></a> [user\_settings](#input\_user\_settings) | List of user settings for the AppStream stack | <pre>list(object({<br>    action     = string<br>    permission = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "CLIPBOARD_COPY_FROM_LOCAL_DEVICE",<br>    "permission": "ENABLED"<br>  },<br>  {<br>    "action": "CLIPBOARD_COPY_TO_LOCAL_DEVICE",<br>    "permission": "ENABLED"<br>  },<br>  {<br>    "action": "FILE_UPLOAD",<br>    "permission": "ENABLED"<br>  },<br>  {<br>    "action": "FILE_DOWNLOAD",<br>    "permission": "ENABLED"<br>  },<br>  {<br>    "action": "PRINTING_TO_LOCAL_DEVICE",<br>    "permission": "ENABLED"<br>  },<br>  {<br>    "action": "DOMAIN_PASSWORD_SIGNIN",<br>    "permission": "DISABLED"<br>  },<br>  {<br>    "action": "DOMAIN_SMART_CARD_SIGNIN",<br>    "permission": "DISABLED"<br>  }<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fleet_name"></a> [fleet\_name](#output\_fleet\_name) | The name of the AppStream 2.0 fleet |
| <a name="output_stack_arn"></a> [stack\_arn](#output\_stack\_arn) | stack ARN |
| <a name="output_stack_name"></a> [stack\_name](#output\_stack\_name) | The name of the AppStream 2.0 stack |
