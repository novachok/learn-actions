output "queue_url" {
  description = "AWS Queue URL"
  value = aws_sqs_queue.events_queue.id
}

output "lambda_arn" {
  description = "AWS Lambda ARN"
  value = aws_lambda_function.input_lambda.arn
}