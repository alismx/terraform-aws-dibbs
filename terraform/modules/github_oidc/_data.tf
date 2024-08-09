data "aws_caller_identity" "current" {}

data "aws_iam_policy" "amazon_vpc_full_access" {
  name = "AmazonVPCFullAccess"
}

data "aws_iam_policy" "amazon_ec2_full_access" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "aws_appmesh_full_access" {
  name = "AWSAppMeshFullAccess"
}

data "aws_iam_policy" "amazon_dynamodb_full_access" {
  name = "AmazonDynamoDBFullAccess"
}

# no ecr, servicediscovery or ecs policies available

data "aws_iam_policy" "elastic_load_balancing_full_access" {
  name = "ElasticLoadBalancingFullAccess"
}

data "aws_iam_policy" "aws_iam_full_access" {
  name = "IAMFullAccess"
}

data "aws_iam_policy" "aws_logs_full_access" {
  name = "CloudWatchLogsFullAccess"
}

data "aws_iam_policy" "aws_s3_full_access" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "amazon_route53_full_access" {
  name = "AmazonRoute53FullAccess"
}

# # create a role that can be assumed to pull and push docker images from 
data "aws_iam_policy_document" "github_assume_role" {
  statement {
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com", ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.oidc_github_repo}:*",
      ]
    }
  }
}

# TODO: https://github.com/CDCgov/dibbs-aws/issues/8
# trivy:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "tfstate" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "s3:*"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "github" {
  statement {
    actions = [
      "appmesh:DescribeMesh",
      "appmesh:ListTagsForResource",
      "ecs:DescribeClusters",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeSubnets",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTags",
      "appmesh:DescribeVirtualNode",
      "ec2:DescribeSecurityGroupRules",
      "elasticloadbalancing:DescribeLoadBalancers",
      "ec2:DescribeNatGateways",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "ec2:DescribeFlowLogs",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "appmesh:DeleteVirtualNode",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ecs:DeleteService",
      "ec2:DeleteFlowLogs",
      "ec2:DeleteNatGateway",
      "appmesh:DeleteMesh",
      "elasticloadbalancing:DeleteLoadBalancer",
      "ec2:DeleteSecurityGroup",
      "ecs:DeleteCluster",
      "ecs:DeregisterTaskDefinition",
      "elasticloadbalancing:DeleteTargetGroup",
      "ec2:DeleteSubnet",
      "appmesh:CreateMesh",
      "ecs:CreateCluster",
      "ecs:RegisterTaskDefinition",
      "iam:PassRole",
      "ec2:DeleteNetworkAclEntry",
      "ec2:CreateTags",
      "ec2:CreateInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateSubnet",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:AddTags",
      "ec2:CreateSecurityGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "ec2:CreateFlowLogs",
      "logs:CreateLogDelivery",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "elasticloadbalancing:CreateLoadBalancer",
      "ec2:CreateNatGateway",
      "ecs:CreateService",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "ecr:*",
      "iam:*"
    ]
    resources = [
      "*"
    ]
  }
}
      # "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:*", 
      # "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:*/*",
      # "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/*",
      # "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/*",
      # "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/*",
      # "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task/*",
      # "arn:aws:servicediscovery:${var.region}:${data.aws_caller_identity.current.account_id}:namespace/*",
      # "arn:aws:servicediscovery:${var.region}:${data.aws_caller_identity.current.account_id}:service/*"
