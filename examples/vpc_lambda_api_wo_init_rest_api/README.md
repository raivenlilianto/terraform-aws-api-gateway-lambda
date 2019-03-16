# examples/vpc_lambda_api_wo_init_rest_api
========================

This example creates:
- One Api Resource (defined manually Rest Api id & Rest Api root_resource_id), with GET and POST method to invoke same Lambda VPC Function
- Lambda VPC function
- IAM Role assigned to the lambda with the following policies attached: AWSLambdaBasicExecutionRole and AWSLambdaENIManagementAccess. In addition, additional policy is attached as stated in data. 
