################################
# Global / Feature Flags
################################

variable "enable_vpce" {
  description = "Enable VPC endpoint for AppStream streaming"
  type        = bool
  default     = false
}

variable "enable_scaling" {
  description = "Enable or disable auto-scaling policies"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "Base name used for AppStream stack, fleet, and IAM resources"
  type        = string
}

variable "appstream_machine_policy" {
  description = "IAM policy for appstream_machine_role"
  type        = string
  default     = "{\"Statement\":[{\"Action\":[\"s3:ListBucket\"],\"Effect\":\"Allow\",\"Resource\":[\"*\"]}],\"Version\":\"2012-10-17\"}"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

################################
# Fleet Configuration
################################

variable "instance_type" {
  description = "AppStream instance type"
  type        = string
  default     = "stream.standard.medium"
}

variable "fleet_type" {
  description = "Fleet type: ON_DEMAND or ALWAYS_ON"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "ALWAYS_ON"], var.fleet_type)
    error_message = "fleet_type must be ON_DEMAND or ALWAYS_ON"
  }
}

variable "image_name" {
  description = "AppStream image name"
  type        = string
  default     = "AppStream-WinServer2022-11-10-2025"
}

variable "stream_view" {
  description = "Stream view: DESKTOP or APPS"
  type        = string
  default     = "DESKTOP"

  validation {
    condition     = contains(["DESKTOP", "APPS"], var.stream_view)
    error_message = "stream_view must be DESKTOP or APPS"
  }
}

variable "enable_default_internet_access" {
  description = "Enable default internet access for fleet instances"
  type        = bool
  default     = false
}

variable "desired_instances" {
  description = "Initial desired number of fleet instances"
  type        = number
  default     = 1
}

variable "max_user_duration_in_seconds" {
  description = "Maximum user session duration"
  type        = number
  default     = 600
}

variable "disconnect_timeout_in_seconds" {
  description = "Disconnect timeout"
  type        = number
  default     = 300
}

variable "idle_disconnect_timeout_in_seconds" {
  description = "Idle disconnect timeout"
  type        = number
  default     = 600
}

################################
# Auto Scaling Configuration
################################

variable "min_capacity" {
  description = "Minimum fleet capacity"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum fleet capacity"
  type        = number
  default     = 3
}

variable "scale_up_adjustment" {
  description = "Number of instances to add when scaling up"
  type        = number
  default     = 2
}

variable "scale_down_adjustment" {
  description = "Number of instances to remove when scaling down"
  type        = number
  default     = 2
}

variable "threshold_up" {
  description = "Scale-up threshold (CapacityUtilization %)"
  type        = number
  default     = 50
}

variable "threshold_down" {
  description = "Scale-down threshold (CapacityUtilization %)"
  type        = number
  default     = 30
}

variable "period" {
  description = "CloudWatch alarm period in seconds"
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "Number of CloudWatch periods to evaluate"
  type        = number
  default     = 5
}

variable "period_up" {
  description = "CloudWatch alarm period in seconds for scale-up alarm"
  type        = number
  default     = null
}

variable "evaluation_periods_up" {
  description = "Number of CloudWatch periods to evaluate for scale-up alarm"
  type        = number
  default     = null
}

variable "period_down" {
  description = "CloudWatch alarm period in seconds for scale-down alarm"
  type        = number
  default     = null
}

variable "evaluation_periods_down" {
  description = "Number of CloudWatch periods to evaluate for scale-down alarm"
  type        = number
  default     = null
}

################################
# Network Configuration
################################

variable "vpc_id" {
  description = "VPC ID (required if enable_vpce = true)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for AppStream fleet and VPC endpoint"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for AppStream fleet and VPC endpoint"
  type        = list(string)
}

################################
# Stack Configuration
################################

variable "user_settings" {
  description = "User settings for the AppStream stack"
  type = list(object({
    action     = string
    permission = string
  }))

  default = [
    { action = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE", permission = "ENABLED" },
    { action = "CLIPBOARD_COPY_TO_LOCAL_DEVICE",   permission = "ENABLED" },
    { action = "FILE_UPLOAD",                      permission = "ENABLED" },
    { action = "FILE_DOWNLOAD",                    permission = "ENABLED" },
    { action = "PRINTING_TO_LOCAL_DEVICE",         permission = "ENABLED" },
    { action = "DOMAIN_PASSWORD_SIGNIN",           permission = "DISABLED" },
    { action = "DOMAIN_SMART_CARD_SIGNIN",         permission = "DISABLED" }
  ]
}

################################
# Active Directory (Optional)
################################

variable "directory_name" {
  description = "Active Directory name (optional)"
  type        = string
  default     = null
}

variable "ou" {
  description = "Organizational Unit DN (optional)"
  type        = string
  default     = null
}

variable "secretsmanager_name" {
  description = "Optional: Name of the Secrets Manager secret containing the service account credentials for AD domain join"
  type        = string
  default     = ""   # empty string = no domain join secret
}
