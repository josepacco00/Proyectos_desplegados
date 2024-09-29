data "aws_iam_policy_document" "Policy_Recognition_Acces" {
  version = "2012-10-17"

  statement {
    actions   = ["rekognition:DetectLabels"]
    resources = ["*"]
  }
}