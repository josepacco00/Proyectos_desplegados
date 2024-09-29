data "aws_iam_policy_document" "Policy_RDS_connect" {
  statement {
    effect = "Allow"
    actions = [
      "rds:DescribeDBInstances",
      "rds:Connect",
      "rds:DescribeDBClusters",
      "rds:DescribeDBClusterEndpoints",
      "rds:DescribeDBClusterSnapshotAttributes",
      "rds:ListTagsForResource",
    ]
    resources = [
      "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:${var.rds_instance_identifier}",
    ]
  }
}