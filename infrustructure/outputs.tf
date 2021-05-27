output "queue_url" {
  description = "AWS Queue URL"
  value = aws_sqs_queue.events_queue.id
}

output "input_lambda_arn" {
  description = "AWS Input Lambda ARN"
  value = aws_lambda_function.input_lambda.arn
}

output "output_lambda_arn" {
  description = "AWS Output Lambda ARN"
  value = aws_lambda_function.output_lambda.arn
}