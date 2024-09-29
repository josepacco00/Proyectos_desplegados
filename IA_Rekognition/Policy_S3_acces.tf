data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.Bucket_IA.id}",
      "arn:aws:s3:::${aws_s3_bucket.Bucket_IA.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.Bucket_IA.id}/recognition/*"
    ]
  }
}
