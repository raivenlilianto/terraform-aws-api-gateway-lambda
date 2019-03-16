output "lambda_arn" {
  value       = "${module.this.lambda_arn}"
  description = "The arn of the lambda"
}

output "role_arn" {
  value       = "${module.this.role_arn}"
  description = "The arn of the role assigned to the lambda"
}

output "aws_api_gateway_rest_api_id" {
  value = "${module.this.aws_api_gateway_rest_api_id}"
}

output "aws_api_gateway_parent_id" {
  value = "${module.this.aws_api_gateway_parent_id}"
}

output "aws_api_gateway_resource_id" {
  value = "${module.this.aws_api_gateway_resource_id}"
}

output "aws_api_gateway_deployment_id" {
  value = "${module.this.aws_api_gateway_deployment_id}"
}

output "aws_api_gateway_deployment_invoke_url" {
  value = "${module.this.aws_api_gateway_deployment_invoke_url}"
}

output "aws_api_gateway_deployment_execution_arn" {
  value = "${module.this.aws_api_gateway_deployment_execution_arn}"
}