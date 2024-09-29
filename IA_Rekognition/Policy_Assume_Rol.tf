data "aws_iam_policy_document" "Policy_Assume_Rol_for_Lambda" {
      version = "2012-10-17"
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    sid       = ""
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

}