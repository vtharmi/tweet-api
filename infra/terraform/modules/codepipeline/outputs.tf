output "pipeline_name" {
  description = "The name of the CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "pipeline_arn" {
  description = "The ARN of the CodePipeline"
  value       = aws_codepipeline.pipeline.arn
}

output "codepipeline_role_arn" {
  description = "The IAM Role ARN used by CodePipeline"
  value       = aws_iam_policy.codepipeline_role.arn
}
