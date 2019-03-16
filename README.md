# API Gateway Resource + AWS Lambda function
=============================

This module is used to provision API Gateway Method and AWS Lambda within VPC to run on being invoked by that API Gateway Method. This will create:
- One API Gateway Resource with the Method(s)
- Lambda function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole and AWSLambdaENIManagementAccess. You could add other policy that the lambda needs.

Module Input Variables
----------------------

- `region` - Region where the lambda is deployed. The default is ap-southeast-1
- `lambda_code_bucket` - The name of the s3 bucket where the deployment resides
- `lambda_code_path` - Name of the S3 deployment object
- `lambda_name` - Unique name for Lambda function
- `lambda_runtime` - A [valid](http://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html#options) Lambda runtime environment
- `lambda_handler` - The entrypoint into your Lambda function
- `lambda_memory_size` - The memory size allocated to your lambda function
- `tags` - Tags associated with the lambda function
- `environment_variables` - Environment variables for your lambda function
- `iam_policy_document` - Additional IAM policy document to be attached to your lambda if the lambda needs to access another AWS resource.
- `schedule_expression` - a [valid rate or cron expression](http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html)
- `subnet_ids` - A list of subnet ids associated with the lambda
- `security_group_ids` - A list of security group ids associated with the lambda
- `is_vpc_lambda` - True if the lambda resides within VPC. False otherwise.
- `rest_api_id` - Specified the Rest API id if it is attached to already define Rest API in API Gateway, if not create once Rest API and attached in one module
- `parent_id` - Specified the Rest API root_resource_id if it is attached to already define Rest API in API Gateway, if not create once Rest API and attached in one module

Usage 
-----
Please look at the complete example.

Outputs
-------
- `lambda_arn` - ARN for the created Lambda function.
- `role_arn` - ARN of the IAM role assigned to the lambda.
- `aws_api_gateway_rest_api_id` - ID of Rest API of API Gateway
- `aws_api_gateway_parent_id` - Root Resource ID of Rest API of API Gateway
- `aws_api_gateway_resource_id` - Resource ID of the API Gateway
- `aws_api_gateway_deployment_id` - ID of the API Gateway Deployment
- `aws_api_gateway_deployment_invoke_url` - Invoke Url of the API Gateway Deployment
- `aws_api_gateway_deployment_execution_arn` - Execution ARN of the API Gateway Deployment

Author
------
- [Adi Novriansyah](https://github.com/adinovriansyah)
