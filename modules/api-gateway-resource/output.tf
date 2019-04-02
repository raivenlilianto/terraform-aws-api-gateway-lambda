output "lambda_arn" {
  value = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
}

output "role_arn" {
  value       = "${module.lambda_role.role_arn}"
  description = "The arn of the role assigned to the lambda"
}

output "aws_api_gateway_rest_api_id" {
  value = "${var.rest_api_id}"
}

output "aws_api_gateway_parent_id" {
  value = "${var.parent_id}"
}

output "aws_api_gateway_resource_id" {
  value = "${aws_api_gateway_resource.api_resource.id}"
}

output "aws_api_gateway_deployment_id" {
  value = "${aws_api_gateway_deployment.deployment.*.id}"
}

output "aws_api_gateway_deployment_invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.*.invoke_url}"
}

output "aws_api_gateway_deployment_execution_arn" {
  value = "${aws_api_gateway_deployment.deployment.*.execution_arn}"
}