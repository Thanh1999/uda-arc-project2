# TODO: Define the variable for aws_region
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "access_key" {
  type    = string
  default = "my-access"
}

variable "secret_key" {
  type    = string
  default = "my-secret"
}

variable "lambda_name" {
  type = string
  default = "my_lambda"
}

variable "zip_name" {
  type = string
  default = "greet_lambda"
}

variable "greeting_value" {
  type = string
  default = "Let's have a happy life"
}