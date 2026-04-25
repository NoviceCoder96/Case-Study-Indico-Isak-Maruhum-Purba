# Technical Take-Home Test - AWS DevSecOps Engineer Position

## Test Overview
As part of our technical evaluation, we would like you to complete a take-home
assignment that demonstrates your skills with Infrastructure Code (IaC) using Terraform.
This test is designed to showcase your ability to create modular, reusable, and wellstructured Terraform configurations for AWS services

## Architecture
S3 (Source) - CodePipeline - CodeBuild - ECS (Fargate)

## Structure Project
terraform/ 
├── main.tf 
├── variables.tf 
├── terraform.tfvars 
├── modules/ 
│ ├── ecs/ 
│ ├── codebuild/ 
│ └── codepipeline/

## Usage
terraform init
terraform validate

## Notes
AWS credential are required for terraform plan
S3 is used for simplicity instead of github
IAM roles follow least priviledges(basic level)
