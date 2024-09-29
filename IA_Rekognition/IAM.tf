#Policy_CloudWatch_logs:
resource "aws_iam_policy" "Policy_CloudWatch_logs" {
    name        = "Policy_CloudWatch_logs"
    description = "Policy_CloudWatch_logs"
    policy = data.aws_iam_policy_document.Policy_Cloud_Watch_Logs.json
}

#Policy_DynamoDB_Acces:
resource "aws_iam_policy" "Policy_DynamoDB" {
    name        = "Policy_DynamoDB_Acces"
    description = "Policy_DynamoDB_Acces"
    policy = data.aws_iam_policy_document.Policy_DynamoDB.json
}

#Policy_S3_acces:
resource "aws_iam_policy" "Policy_S3_acces" {
    name        = "Policy_S3_acces"
    description = "Policy_S3_acces"
    policy = data.aws_iam_policy_document.s3_access_policy.json
    depends_on = [aws_s3_bucket.Bucket_IA]
}

#Policy_Recognition_Acces:
resource "aws_iam_policy" "Policy_Recognition_Acces" {
    name        = "Policy_Recognition_Acces"
    description = "Policy_Recognition_Acces"
    policy = data.aws_iam_policy_document.Policy_Recognition_Acces.json
}

#Policy_Translate_Acces:
resource "aws_iam_policy" "Policy_Translate_Acces" {
    name        = "Policy_Translate_Acces"
    description = "Policy_Translate_Acces"
    policy = data.aws_iam_policy_document.Policy_Translate_Acces.json
}
#################################################################Role_Lambda:
resource "aws_iam_role" "Role_Lambda" {
    name = "Role_Lambda_Proyect_S3_IA"
    assume_role_policy = data.aws_iam_policy_document.Policy_Assume_Rol_for_Lambda.json
}


#Atach_Policy_CloudWatch_logs_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role" {
    role = aws_iam_role.Role_Lambda.name
    policy_arn = aws_iam_policy.Policy_CloudWatch_logs.arn
}

#Atach_Policy_S3_acces_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_1" {
    role = aws_iam_role.Role_Lambda.name
    policy_arn = aws_iam_policy.Policy_S3_acces.arn
}

#Atach_Policy_Recognition_Acces_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_2" {
    role = aws_iam_role.Role_Lambda.name
    policy_arn = aws_iam_policy.Policy_Recognition_Acces.arn
}

#Atach_Policy_DynamoDB_Acces_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_3" {
    role = aws_iam_role.Role_Lambda.name
    policy_arn = aws_iam_policy.Policy_DynamoDB.arn
}

#Atach_Policy_Translate_Acces_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_4" {
    role = aws_iam_role.Role_Lambda.name
    policy_arn = aws_iam_policy.Policy_Translate_Acces.arn
}
####################################################################
resource "aws_iam_role" "Role_lambda_GET" {
    name = "Role_lambda_GET"
    assume_role_policy = data.aws_iam_policy_document.Policy_Assume_Rol_for_Lambda.json
}

#Atach_Policy_DynamoDB_Acces_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_5" {
    role = aws_iam_role.Role_lambda_GET.name
    policy_arn = aws_iam_policy.Policy_DynamoDB.arn
}

#Atach_Policy_CloudWatch_logs_to_Role:
resource "aws_iam_role_policy_attachment" "Atach_Policy_to_Role_6" {
    role = aws_iam_role.Role_lambda_GET.name
    policy_arn = aws_iam_policy.Policy_CloudWatch_logs2.arn
}

#Policy_CloudWatch_logs2:
resource "aws_iam_policy" "Policy_CloudWatch_logs2" {
    name        = "Policy_CloudWatch_logs2"
    description = "Policy_CloudWatch_logs2"
    policy = data.aws_iam_policy_document.Policy_Cloud_Watch_Logs2.json
}