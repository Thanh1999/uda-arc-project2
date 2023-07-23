# Define the AWS provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.zip_name
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

# Create an AWS Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_name 
  role          = aws_iam_role.lambda_role.arn
  handler       = "greet_lambda.lambda_handler" 
  runtime       = "python3.8"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment{
      variables = {
          greeting = var.greeting_value
      }
  }

}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "log_policy" {
  name = "lambda_log_policy"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "log_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.log_policy.arn
}
