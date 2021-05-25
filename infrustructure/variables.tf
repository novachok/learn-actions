variable "aws_profile" {
  description = "AWS credentials profile name"
  type = string
  default = "novachok"
}
variable "lambda_timeout" {
  description = "Lambda runtime timout"
  type = number
  default = 30
}

variable "lambda_memory_limit" {
  description = "Lambda runtime memory limit"
  type = number
  default = 256
}
