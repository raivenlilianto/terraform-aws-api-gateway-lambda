output "api_key_value" {
  value = "${aws_api_gateway_api_key.api_key.value}"
}

output "api_key_id" {
  value = "${aws_api_gateway_api_key.api_key.id}"
}

output "api_key_usage_plan_id" {
  value = "${aws_api_gateway_usage_plan.api_key_usage_plan.id}"
}