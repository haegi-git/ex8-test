
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket        = "${var.tag_header}pipeline-bucket-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name = "${var.tag_header}pipeline-bucket-${random_id.bucket_suffix.hex}"
  }
}


# 생성된 버킷의 버전관리 활성화(CodePipeline에서 필수 속성)
resource "aws_s3_bucket_versioning" "pipeline_bucket_versioning" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# 퍼블릭 엑세스 전체 차단 (보안 규정 준수)
resource "aws_s3_bucket_public_access_block" "pipeline_bucket_public_access" {
  bucket                  = aws_s3_bucket.pipeline_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 서버 측 기본 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_bucket_encryption" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # SSE-S3 암호화 알고리즘
    }
  }
}
