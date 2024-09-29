########################################## Policy for Lambda

resource "aws_iam_policy" "Policy_Cloud_Watch_Logs" {
    name        = "Policy_Cloud_Watch_Logs"
    policy = data.aws_iam_policy_document.Policy_Cloud_Watch_Logs.json
}

resource "aws_iam_policy" "Policy_RDS_connect" {
    name        = "Policy_RDS_connect"
    policy = data.aws_iam_policy_document.Policy_RDS_connect.json
}

resource "aws_iam_policy" "Policy_Parameter_Store" {
    name        = "Policy_Parameter_Store"
    policy = data.aws_iam_policy_document.Policy_Parameter_Store.json
}

resource "aws_iam_policy" "Policy_Network_Interface" {
    name        = "Policy_Network_Interface"
    policy = data.aws_iam_policy_document.Policy_Network_Interface.json
}

########################################### Role for Lambda
resource "aws_iam_role" "Role_for_Lambda" {
    name = "Role_for_Lambda"
    assume_role_policy = data.aws_iam_policy_document.Policy_Assume_Rol.json
}

########################################### Attachments
resource "aws_iam_role_policy_attachment" "Policy_Cloud_Watch_Logs" {
    role       = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_Cloud_Watch_Logs.arn
}

resource "aws_iam_role_policy_attachment" "Policy_RDS_connect" {
    role       = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_RDS_connect.arn
}

resource "aws_iam_role_policy_attachment" "Policy_Parameter_Store" {
    role       = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_Parameter_Store.arn
}

resource "aws_iam_role_policy_attachment" "Policy_Network_Interface" {
    role       = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_Network_Interface.arn
}