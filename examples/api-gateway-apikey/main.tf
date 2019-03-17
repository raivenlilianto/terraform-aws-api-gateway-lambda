provider "aws" {
  region = "ap-southeast-1"
}

module "this" {
  source = "../../modules/api-gateway-apikey"

  rest_api_id         = "eobgt8gwvh"
  stage_name          = "v1"
  api_key_name        = "astvcc-axtprsv-key"
  api_key_description = "api key astvcc for axtprsv"
}