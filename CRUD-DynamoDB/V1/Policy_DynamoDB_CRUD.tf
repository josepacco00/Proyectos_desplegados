data "aws_iam_policy_document" "Policy_DynamoDB_CRUD" {
  version = "2012-10-17"

  statement {
    actions   = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.Table_DynamoDB_CRUD_Name}"
    ]
  }
}