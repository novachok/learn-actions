terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.42"
    }
  }

  backend "s3" {
    bucket  = "novachok-infra-state"
    key     = "test"
    region  = "us-east-2"
    profile = "novachok"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "novachok"
  region  = "us-east-2"
}

resource "aws_iam_role" "test_lambda_role" {
  name               = "test_lambda_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda.zip"
  function_name = "test_lambda"
  role          = aws_iam_role.test_lambda_role.arn
  handler       = "app.handler"
  runtime       = "python3.8"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_limit
}