resource "aws_iam_role" "rds_lambda_role" {
  name                  = "rds-lambda-role"
  assume_role_policy    = data.aws_iam_policy_document.lambda_assume_role.json
  force_detach_policies = true
}

resource "aws_iam_policy" "rds_lambda_policy" {
  name        = "rds-lambda-policy"
  description = "This is the IAM policy for the rds lambda"
  policy      = data.aws_iam_policy_document.rds_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "rds_lambda_policy_attach" {
  role       = aws_iam_role.rds_lambda_role.name
  policy_arn = aws_iam_policy.rds_lambda_policy.arn
}


resource "aws_iam_role_policy_attachment" "aws_lambda_vpc_access_role_policy_attach" {
  role       = aws_iam_role.rds_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "lambda_assume_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}



data "aws_iam_policy_document" "rds_lambda_policy" {
  version = "2012-10-17"
  statement {
    sid    = "VisualEditor0"
    effect = "Allow"
    actions = [
      "rds:DescribeDBClusterParameters",
      "rds:StartDBCluster",
      "rds:StopDBCluster",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeGlobalClusters",
      "rds:DescribePendingMaintenanceActions",
      "rds:DescribeDBLogFiles",
      "rds:StopDBInstance",
      "rds:StartDBInstance",
      "rds:DescribeReservedDBInstancesOfferings",
      "rds:DescribeReservedDBInstances",
      "rds:ListTagsForResource",
      "rds:DescribeValidDBInstanceModifications",
      "rds:DescribeDBInstances",
      "rds:DescribeSourceRegions",
      "rds:DescribeDBClusterEndpoints",
      "rds:DescribeDBClusters",
      "rds:DescribeDBClusterParameterGroups",
      "rds:DescribeOptionGroups"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowKms"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}


#Datasync Instance Role

# resource "aws_iam_role" "datasync_service_role" {
#   name                  = "datasync-service-role"
#   assume_role_policy    = data.aws_iam_policy_document.datasync_service_assume_role.json
#   force_detach_policies = true
#   tags = {
#     "Name" = "datasync-service-role"
#   }
# }

# data "aws_iam_policy_document" "datasync_service_assume_role" {

#   statement {
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["datasync.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_policy" "datasync_service_policy" {
#   name        = "datasync-service-policy"
#   description = "This is the IAM policy for the datasync instance"
#   policy      = data.aws_iam_policy_document.datasync_service_policy.json
# }

# data "aws_iam_policy_document" "datasync_service_policy" {
#   version = "2012-10-17"
#   statement {
#     sid    = "DataSyncPermissions"
#     effect = "Allow"
#     actions = [
#       "datasync:CreateTask",
#       "datasync:UpdateTask",
#       "datasync:ListAgents",
#       "datasync:DescribeLocationS3",
#       "datasync:DescribeLocationNFS"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     sid    = "SourcebucketPermission"
#     effect = "Allow"
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#       "s3:GetBucketLocation",
#       "s3:DeleteObject",
#     ]
#     resources = [
#       "${aws_s3_bucket.s3_bucket["terraform-state-bucket-001"].arn}",
#       "${aws_s3_bucket.s3_bucket["terraform-state-bucket-001"].arn}/*"
#     ]
#   }
# }

# resource "aws_iam_role_policy_attachment" "datasync_service_policy_attach" {
#   role       = aws_iam_role.datasync_service_role.name
#   policy_arn = aws_iam_policy.datasync_service_policy.arn
# }
