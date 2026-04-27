resource "aws_cognito_user_pool" "end_users" {
  name = "declara-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_client" "flutter_app" {
  name = "declara-flutter-app"

  user_pool_id = aws_cognito_user_pool.end_users.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
  ]
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_generation_lambda" {
  name               = "declara-task-generation-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "task_generation_lambda_basic_execution" {
  role       = aws_iam_role.task_generation_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// terraform apply時に自動でLambdaで実行するjsファイルをZip化する
data "archive_file" "task_generation_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_placeholder/index.js"
  output_path = "${path.module}/lambda_placeholder.zip"
}

resource "aws_lambda_function" "task_generation" {
  function_name = "declara-task-generation"
  role          = aws_iam_role.task_generation_lambda.arn

  runtime = "nodejs20.x"
  handler = "index.handler"

  filename         = data.archive_file.task_generation_lambda.output_path
  source_code_hash = data.archive_file.task_generation_lambda.output_base64sha256
}

module "task_generation_api" {
  source = "./modules/http_api"

  api_name                 = "declara-task-generation-api"
  route_key                = "POST /generate-tasks"
  lambda_function_name     = aws_lambda_function.task_generation.function_name
  lambda_invoke_arn        = aws_lambda_function.task_generation.invoke_arn
  cognito_user_pool_issuer = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.end_users.id}"
  cognito_client_id        = aws_cognito_user_pool_client.flutter_app.id
}
