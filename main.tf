provider "aws" {
  region = var.region
}

module "ecs" {
  source = "./modules/ecs"

  project_name    = var.project_name
  environment     = var.environment
  container_image = var.container_image

  subnets        = [aws_subnet.this.id]
  security_group = aws_security_group.ecs_sg.id
}

module "codebuild" {
  source = "./modules/codebuild"

  project_name = var.project_name
}

module "codepipeline" {
  source = "./modules/codepipeline"

  project_name            = var.project_name
  codebuild_project_name = module.codebuild.project_name

  pipeline_role = aws_iam_role.codepipeline_role.arn
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name}-ecs-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}