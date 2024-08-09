resource "random_string" "oidc" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_iam_policy" "github" {
  name   = "${var.project}-github-policy-${var.owner}-${random_string.oidc.result}"
  policy = data.aws_iam_policy_document.github.json
}

resource "aws_iam_policy" "tfstate" {
  name   = "${var.project}-tfstate-policy-${var.owner}-${random_string.oidc.result}"
  policy = data.aws_iam_policy_document.tfstate.json
}

resource "aws_iam_role" "github" {
  name = "${var.project}-github-role-${var.owner}-${random_string.oidc.result}"
  managed_policy_arns = [
    aws_iam_policy.github.arn,
    aws_iam_policy.tfstate.arn,
    # data.aws_iam_policy.amazon_vpc_full_access.arn,
    # data.aws_iam_policy.amazon_ec2_full_access.arn,
    # data.aws_iam_policy.aws_appmesh_full_access.arn,
    # data.aws_iam_policy.amazon_dynamodb_full_access.arn,
    # data.aws_iam_policy.elastic_load_balancing_full_access.arn,
    # data.aws_iam_policy.aws_iam_full_access.arn,
    # data.aws_iam_policy.aws_logs_full_access.arn,
    # data.aws_iam_policy.aws_s3_full_access.arn,
    # data.aws_iam_policy.amazon_route53_full_access.arn,
  ]
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}