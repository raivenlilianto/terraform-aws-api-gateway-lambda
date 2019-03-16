data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowReadOfAParameter"
    effect = "Allow"

    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParametersByPath",
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [
      "${local.system_manager_parameter_arn}",
    ]
  }

  statement {
    sid    = "AllowDecryptDescribeParameter"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    resources = [
      "${local.system_manager_kms_key_arn}",
    ]
  }

  statement {
    sid    = "AllowDescribeLogStreams"
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
    ]

    resources = [
      "${local.cwl_log_group_arn}",
    ]
  }
}