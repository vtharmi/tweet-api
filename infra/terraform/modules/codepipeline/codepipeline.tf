resource "aws_codepipeline" "pipeline" {
  name     = "${var.app_name}-${terraform.workspace}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.artifact_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Deploy-${var.app_name}-${terraform.workspace}"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = "${var.app_name}-${terraform.workspace}"
        DeploymentGroupName = "${var.app_name}-${terraform.workspace}"
      }
    }
  }
}

resource "aws_iam_policy" "codepipeline_s3_policy" {
  name = "${var.app_name}-codepipeline-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      Resource = "arn:aws:s3:::${var.app_name}-s3-bucket-${terraform.workspace}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}
