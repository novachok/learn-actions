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

resource "aws_sqs_queue" "events_queue" {
  name  = "events_queue"
  visibility_timeout_seconds = 120
}

resource "aws_iam_role" "input_lambda_role" {
  name               = "input_lambda_role"
  assume_role_policy = jsonencode({
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
  })
}

resource "aws_iam_role" "output_lambda_role" {
  name               = "output_lambda_role"
  assume_role_policy = jsonencode({
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
  })
}

resource "aws_iam_policy" "sqs_write_policy" {
  name = "sqs_write_allowness"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Sid": "AllowSqsWrite",
      "Effect": "Allow",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.events_queue.arn}"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "input_lambda_policy" {
  role = aws_iam_role.input_lambda_role.name
  policy_arn = aws_iam_policy.sqs_write_policy.arn
}

resource "aws_lambda_function" "input_lambda" {
  filename      = "lambda.zip"
  function_name = "input_lambda"
  role          = aws_iam_role.input_lambda_role.arn
  handler       = "app.handler"
  runtime       = "python3.8"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_limit

  environment {
    variables = {
      "QUEUE_URL" = aws_sqs_queue.events_queue.id
    }
  }
}

resource "aws_lambda_function" "output_lambda" {
  filename      = "lambda.zip"
  function_name = "output_lambda"
  role          = aws_iam_role.output_lambda_role.arn
  handler       = "app.handler"
  runtime       = "python3.8"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_limit
}