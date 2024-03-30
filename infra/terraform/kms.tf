# resource "aws_kms_key" "s3" {
#   description         = "KMS CMK for S3"
#   enable_key_rotation = true
#   policy = jsonencode(
#     {
#       Id = "key-default-1"
#       Statement = [
#         {
#           Action = "kms:*"
#           Effect = "Allow"
#           Principal = {
#             AWS = "arn:aws:iam::670213391116:root"
#           }
#           Resource = "*"
#           Sid      = "Enable IAM User Permissions"
#         }
#       ]
#       Version = "2012-10-17"
#     }

#   )
# }
# resource "aws_kms_alias" "s3" {
#   name          = "alias/cmk/s3"
#   target_key_id = aws_kms_key.s3.key_id
# }