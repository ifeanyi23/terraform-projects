# resource "aws_datasync_location_s3" "s3_source_location" {
#   s3_bucket_arn = aws_s3_bucket.s3_bucket["terraform-state-bucket-001"].arn
#   subdirectory  = "efs-files/"
#   # Other configuration options
#   s3_config {
#     bucket_access_role_arn = aws_iam_role.datasync_service_role.arn
#   }
# }

# resource "aws_datasync_location_efs" "efs_destination_location" {
#   # The below example uses aws_efs_mount_target as a reference to ensure a mount target already exists when resource creation occurs.
#   # You can accomplish the same behavior with depends_on or an aws_efs_mount_target data source reference.
#   efs_file_system_arn = aws_efs_mount_target.az3.file_system_arn

#   ec2_config {
#     security_group_arns = [aws_security_group.datasync_service_sg.arn]
#     subnet_arn          = aws_subnet.subnet_3.arn
#   }
# }

# resource "aws_datasync_task" "datasync_service_task" {
#   destination_location_arn = aws_datasync_location_efs.efs_destination_location.arn
#   name                     = "datasync service task"
#   source_location_arn      = aws_datasync_location_s3.s3_source_location.arn

#   options {
#     posix_permissions = "NONE"
#     bytes_per_second  = -1
#     uid               = "NONE"
#     gid               = "NONE"
#   }
# }