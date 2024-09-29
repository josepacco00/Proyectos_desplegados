data "aws_iam_policy_document" "Policy_Network_Interface" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["*"]  # No se puede restringir más en este caso
  }
}