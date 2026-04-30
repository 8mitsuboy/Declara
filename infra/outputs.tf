output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool for end users."
  value       = aws_cognito_user_pool.end_users.id
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client for the Flutter app."
  value       = aws_cognito_user_pool_client.flutter_app.id
}

output "cognito_issuer_url" {
  description = "Issuer URL for Cognito JWT tokens."
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.end_users.id}"
}

output "task_generation_lambda_function_name" {
  description = "Name of the Lambda function for task generation."
  value       = aws_lambda_function.task_generation.function_name
}

output "task_generation_api_endpoint" {
  description = "Base endpoint URL of the task generation API."
  value       = module.task_generation_api.api_endpoint
}
