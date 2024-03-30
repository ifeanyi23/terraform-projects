resource "aws_s3_bucket" "s3_bucket" {
  for_each      = var.s3_buckets
  bucket        = "${local.workspace["environment"]}-${each.key}"
  force_destroy = each.value.force_destroy
  tags = {
    Name = "${local.workspace["environment"]}-${each.key}"
  }
}



resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  for_each                = var.s3_buckets
  bucket                  = aws_s3_bucket.s3_bucket[each.key].id
  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  for_each = var.s3_buckets
  bucket   = aws_s3_bucket.s3_bucket[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = each.value.kms_master_key_id
      sse_algorithm     = each.value.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  for_each = var.s3_buckets
  bucket   = aws_s3_bucket.s3_bucket[each.key].id

  versioning_configuration {
    status = each.value.versioning
  }
}

#Used to create the directory for static files
resource "aws_s3_object" "s3_bucket" {
  for_each = { for key, value in var.s3_buckets : key => value if value.create_object }

  bucket                 = aws_s3_bucket.s3_bucket[each.key].id
  key                    = var.s3_buckets[each.key].object_key
  source                 = var.s3_buckets[each.key].object_source
  server_side_encryption = var.s3_buckets[each.key].server_side_encryption
  content_type           = var.s3_buckets[each.key].content_type
}