resource "aws_s3_bucket_object" "etcd3-bootstrap-linux-amd64" {
  bucket       = local.aws_s3_bucket_name 
  key          = local.aws_s3_bucket_etcd_bootstrap_key
  source       = "files/etcd3-bootstrap-linux-amd64"
  etag         = filemd5("files/etcd3-bootstrap-linux-amd64")
  acl          = "public-read"
  content_type = "application/octet-stream"
}

