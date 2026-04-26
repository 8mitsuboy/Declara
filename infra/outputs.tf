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
