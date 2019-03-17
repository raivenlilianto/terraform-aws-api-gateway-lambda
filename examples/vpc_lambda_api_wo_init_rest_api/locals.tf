locals {
    lambda_code_bucket = "ast-appbin-112120735838-8bdd3e766153c31a"
    lambda_code_path = "astvcc/staging/8a9bf71-astvcc-test.zip"
    lambda_name = "astvcc-apiReleasePoolData"
    lambda_runtime = "java8"
    lambda_handler = "com.traveloka.ast.vcc.lambda.ReleasePoolData::execute"
    lambda_memory_size = "512"
    lambda_timeout = "15"
    subnet_ids = ["subnet-0352c647a6d30b213", "subnet-07f7b5ee6d2e6fe16", "subnet-0bf352303d5803eba"]
    security_group_ids = []
    environment = "development"
    product_domain = "ast"
    service_name = "astvcc"
    environment_variables = {
        env     = "stg"
    }
    tags = {
        Service = "astvcc"
        Type    = "schedule-lambda"
    }
    vpc_id = "vpc-092a5830438079182"
    system_manager_parameter_arn = "arn:aws:ssm:ap-southeast-1:112120735838:parameter/tvlk-secret/astvcc/*"
    cwl_log_group_arn = "arn:aws:logs:ap-southeast-1:112120735838:log-group:/tvlk/app-java/astvcc/*"
    system_manager_kms_key_arn = "arn:aws:kms:ap-southeast-1:112120735838:key/63ed2221-9a72-4f2d-af6a-64906ea5293e"

    rest_api_id = "eobgt8gwvh"
    parent_id = "2f5xpd0wu6"
}