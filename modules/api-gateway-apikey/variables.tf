variable "rest_api_id" {
  type        = "string"
  description = "Rest Api Id"
}

variable "stage_name" {
  type        = "string"
  description = "The API Gateway Deployment stage"
}

variable "api_key_name" {
  type        = "string"
  description = "The name of the API key"
}

variable "api_key_description" {
  type        = "string"
  description = "The API key description"
  default     = ""
}
