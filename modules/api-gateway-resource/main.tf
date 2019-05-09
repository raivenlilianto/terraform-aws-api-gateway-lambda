module "lambda_role" {
  source = "github.com/traveloka/terraform-aws-iam-role//modules/lambda?ref=v0.4.4"

  product_domain   = "${var.product_domain}"
  descriptive_name = "${var.lambda_name}"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_role" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_eni_management" {
  role       = "${module.lambda_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  count      = "${var.is_vpc_lambda == "true" ? 1 : 0}"
}

resource "aws_iam_role_policy" "lambda_additional_policy" {
  name   = "${var.lambda_name}"
  role   = "${module.lambda_role.role_name}"
  policy = "${var.iam_policy_document}"
  count  = "${length(var.iam_policy_document) > 0 ? 1 : 0}"
}

module "random_id" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.7.1"

  name_prefix   = "${var.product_domain}-${var.lambda_name}"
  resource_type = "lambda_function"
}

locals {
  default_tags = {
    Name          = "${var.lambda_name}"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
    Description   = "${var.lambda_description}"
    ManagedBy     = "Terraform"
  }
}

resource "aws_lambda_function" "lambda_classic" {
  s3_bucket     = "${var.lambda_code_bucket}"
  s3_key        = "${var.lambda_code_path}"
  function_name = "${module.random_id.name}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }

  count = "${var.is_vpc_lambda == "true" ? 0 : 1}"
}

resource "aws_lambda_function" "lambda_vpc" {
  s3_bucket     = "${var.lambda_code_bucket}"
  s3_key        = "${var.lambda_code_path}"
  function_name = "${module.random_id.name}"
  description   = "${var.lambda_description}"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "${var.lambda_runtime}"
  handler       = "${var.lambda_handler}"
  memory_size   = "${var.lambda_memory_size}"
  timeout       = "${var.lambda_timeout}"

  tags = "${merge(local.default_tags, var.tags)}"

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment = {
    variables = "${merge(var.environment_variables, map("ManagedBy", "Terraform"))}"
  }

  count = "${var.is_vpc_lambda == "true" ? 1 : 0}"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "${var.path_part}"
}

resource "aws_api_gateway_method" "api_method" {
  count         = "${length(var.http_methods)}"

  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${aws_api_gateway_resource.api_resource.id}"
  http_method   = "${element(var.http_methods, count.index)}"
  authorization = "${var.authorization}"
  authorizer_id = "${var.authorizer_id}"
  api_key_required = "${element(var.http_methods_apikey_required, count.index)}" 
}

resource "aws_api_gateway_method_response" "200" {
  count       = "${length(var.http_methods)}"

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${element(aws_api_gateway_method.api_method.*.http_method, count.index)}"
  status_code = "200"

  response_models = { "application/json" = "Empty" }
}

resource "aws_api_gateway_integration" "api_method_integration" {
  count                   = "${length(var.http_methods)}"

  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${aws_api_gateway_resource.api_resource.id}"
  http_method             = "${element(aws_api_gateway_method.api_method.*.http_method, count.index)}"
  type                    = "AWS_PROXY"
  uri                     = "${join("", concat(aws_lambda_function.lambda_vpc.*.invoke_arn, aws_lambda_function.lambda_classic.*.invoke_arn))}"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration_response" "api_method_integration_response" {
  count       = "${length(var.http_methods)}"

  depends_on = [
    "aws_api_gateway_integration.api_method_integration"
  ] 

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${element(aws_api_gateway_method.api_method.*.http_method, count.index)}"
  status_code = "${element(aws_api_gateway_method_response.200.*.status_code, count.index)}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_integration.api_method_integration",
    "aws_api_gateway_method.api_method"
  ]

  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"

  variables = {
    deployed_at = "${timestamp()}"
  }

  count = "${var.is_deployed == "true" ? 1 : 0}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:ap-southeast-1:${var.account_id}:${var.rest_api_id}/${aws_api_gateway_deployment.deployment.stage_name}/*"
}