data "aws_iam_policy_document" "Policy_Translate_Acces" {
  version = "2012-10-17"

  statement {
    actions   = ["translate:TranslateText"]
    resources = ["*"] # Permite acceso a todos los recursos de Translate
  }
}