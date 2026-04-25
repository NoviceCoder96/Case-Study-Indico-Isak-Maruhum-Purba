resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-artifacts"

  tags = {
    Project = var.project_name
  }
}

resource "aws_codepipeline" "this" {
  name     = "${var.project_name}-pipeline"
  role_arn = var.pipeline_role

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  ##################################
  # SOURCE STAGE (S3 - NO GITHUB)
  ##################################
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket    = aws_s3_bucket.artifacts.bucket
        S3ObjectKey = "dummy.zip"
        PollForSourceChanges = "false"
      }
    }
  }

  ##################################
  # BUILD STAGE
  ##################################
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  ##################################
  # (OPTIONAL) DEPLOY STAGE - ECS
  ##################################
  # Uncomment kalau nanti ECS sudah siap
  #
  # stage {
  #   name = "Deploy"
  #
  #   action {
  #     name            = "Deploy"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "ECS"
  #     version         = "1"
  #     input_artifacts = ["build_output"]
  #
  #     configuration = {
  #       ClusterName = var.ecs_cluster_name
  #       ServiceName = var.ecs_service_name
  #       FileName    = "imagedefinitions.json"
  #     }
  #   }
  # }

  tags = {
    Project = var.project_name
  }
}