resource "aws_api_gateway_api_key" "api_key" {
  name        = "${var.api_key_name}"
  description = "${var.api_key_description}"
}

resource "aws_api_gateway_usage_plan" "api_key_usage_plan" {
  name         = "${var.api_key_name}-usage-plan"

  api_stages {
    api_id = "${var.rest_api_id}"
    stage  = "${var.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api_key_usage_plan.id}"
}