variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner/org name"
  type        = string
}

variable "github_branch" {
  description = "Branch name to pull from"
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for access"
  type        = string
  sensitive   = true
}

variable "artifact_bucket_name" {
  type        = string
  description = "S3 bucket name used for storing CodePipeline artifacts"
}