variable "api_name" {
  description = "Name of the API Gateway HTTP API."
  type        = string
}

variable "route_key" {
  description = "Route key that exposes the Lambda integration."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function integrated with the HTTP API."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function integrated with the HTTP API."
  type        = string
}

variable "cognito_user_pool_issuer" {
  description = "Issuer URL for Cognito JWT tokens."
  type        = string
}

variable "cognito_client_id" {
  description = "Cognito User Pool Client ID accepted by the JWT authorizer."
  type        = string
}
