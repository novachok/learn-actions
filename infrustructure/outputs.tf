output "queue_url" {
  description = "AWS Queue URL"
  value = aws_sqs_queue.test_queue.id
}

output "lambda_arn" {
  description = "AWS Lambda ARN"
  value = aws_lambda_function.test_lambda.arn
}