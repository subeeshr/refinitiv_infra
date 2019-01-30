data "aws_elb_service_account" "main" { }

resource "aws_s3_bucket" "refinitiv_bucket_elb_logs" {
  bucket = "${var.s3_bucket_name}"
  acl = "${var.s3_bucket_acl}"
  region = "${var.aws_region}"

  lifecycle_rule {
    id = "delete-old-logs"
    prefix = "AWSLogs/"
    enabled = true
    expiration {
      days = 30
    }
  }
# Allow the ALB to upload logs.
  policy = <<POLICY
{
"Id": "Policy",
"Version": "2012-10-17",
"Statement": [
{
  "Action": [
    "s3:PutObject"
  ],
  "Effect": "Allow",
  "Resource": "arn:aws:s3:::${var.s3_bucket_name}/AWSLogs/*",
  "Principal": {
    "AWS": [
      "${data.aws_elb_service_account.main.id}"
    ]
  }
},
{
  "Action": "s3:*",
  "Effect": "Allow",
  "Principal": "*",
  "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
  "Condition": {
    "Bool": {
      "aws:SecureTransport": false
    }
  }
}]
}
POLICY
  tags {
    env = "${var.env}"
    project = "${var.project}"
    terraform = "true"
  }
}
