provider "aws" {
  region = "us-west-2"
}

module "appstream" {
  source = "git::https://git@github.com/ucopacme/terraform-aws-appstream.git//?ref=v0.0.4" # change to your module path or git repo

  # Global
  name   = "stackname"
  region = "us-west-2"
  # Network
  vpc_id             = "vpc-Id"
  subnet_ids         = ["subnet-id", "subnet-id"]
  security_group_ids = ["sg-id"]

  # Fleet
  instance_type                  = "stream.standard.medium"
  fleet_type                     = "ON_DEMAND"
  image_name                     = "AppStream-WinServer2022-11-10-2025"
  desired_instances              = 1
  min_capacity                   = 1
  max_capacity                   = 5
  enable_default_internet_access = false # the fleet must be deployed in a public subnet (with a route to an Internet Gateway).
  stream_view                    = "DESKTOP"

  max_user_duration_in_seconds       = 3600
  disconnect_timeout_in_seconds      = 300
  idle_disconnect_timeout_in_seconds = 900

  # Auto Scaling
  enable_scaling        = true
  scale_up_adjustment   = 1
  scale_down_adjustment = 1
  threshold_up          = 60
  threshold_down        = 30
  period                = 300
  evaluation_periods    = 2

  # Stack behavior
  user_settings = [
    { action = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE", permission = "ENABLED" },
    { action = "CLIPBOARD_COPY_TO_LOCAL_DEVICE", permission = "ENABLED" },
    { action = "FILE_UPLOAD", permission = "ENABLED" },
    { action = "FILE_DOWNLOAD", permission = "ENABLED" },
    { action = "PRINTING_TO_LOCAL_DEVICE", permission = "ENABLED" }
  ]
 tags = {
    Environment = "prod"
    Owner       = "IT"
    application = "test"
  }

  # Active Directory join (optional)
  # To domain-join the AppStream fleet:
# 1. Provide your AD domain name in `directory_name`
# 2. Provide the Organizational Unit path in `ou`
# 3. Store a service account in Secrets Manager and provide its name in `secretsmanager_name`
  # directory_name      = "corp.example.com"
  # ou                  = "OU=AppStream,DC=corp,DC=example,DC=com"
  # secretsmanager_name = "AppStreamDomainJoinServiceAccount"

}
