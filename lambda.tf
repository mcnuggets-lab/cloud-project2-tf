resource "aws_lambda_function" "lambda_function" {
  function_name                  = "${var.project_name}-lambda"
  image_uri                      = data.aws_ecr_image.docker_image.image_uri
  memory_size                    = 1024
  package_type                   = "Image"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  skip_destroy                   = false
  tags                           = local.common_tags
  timeout                        = 30
}

data "aws_iam_policy_document" "lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name                 = "${var.project_name}-lambdaRole"
  assume_role_policy   = data.aws_iam_policy_document.lambda_iam_policy_document.json
  max_session_duration = 3600
  tags                 = local.common_tags
}
