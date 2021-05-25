output "lambda_arn" {
  description = "AWS Lambda ARN"
  value = aws_lambda_function.test_lambda.arn
}