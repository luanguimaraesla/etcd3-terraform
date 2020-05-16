resource "aws_iam_role" "lambda-cloudwatch-dns-service" {
  name = local.aws_lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "lambda-cloudwatch-dns-service" {
  name = local.aws_lambda_name
  role = aws_iam_role.lambda-cloudwatch-dns-service.name

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "autoscaling:DescribeAutoScalingGroups",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "lambda-cloudwatch-dns-service-xray" {
  role       = aws_iam_role.lambda-cloudwatch-dns-service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda-cloudwatch-dns-service-logs" {
  role       = aws_iam_role.lambda-cloudwatch-dns-service.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "archive_file" "lambda-dns-service" {
  type        = "zip"
  source_file = "${path.module}/files/lambda-dns-service/dist/bundle.js"
  output_path = "${path.module}/files/lambda-dns-service.dist.zip"
}

resource "aws_lambda_function" "cloudwatch-dns-service" {
  filename         = "${path.module}/files/lambda-dns-service.dist.zip"
  source_code_hash = data.archive_file.lambda-dns-service.output_base64sha256
  function_name    = local.aws_lambda_name
  role             = aws_iam_role.lambda-cloudwatch-dns-service.arn
  handler          = "bundle.handler"
  runtime          = "nodejs8.10"
  timeout          = 10

  depends_on = [
    data.archive_file.lambda-dns-service,
    aws_iam_role_policy_attachment.lambda-cloudwatch-dns-service-xray,
  ]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      HOSTED_ZONE_ID = local.aws_route53_zone_id
      DOMAIN         = local.aws_route53_etcd_domain
    }
  }
}

resource "aws_cloudwatch_event_rule" "autoscaling" {
  name       = "autoscaling-${local.aws_lambda_name}"
  depends_on = [aws_lambda_function.cloudwatch-dns-service]

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful",
    "EC2 Instance Terminate Successful",
    "EC2 Instance Launch Unsuccessful",
    "EC2 Instance Terminate Unsuccessful"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "lambda-cloudwatch-dns-service-autoscaling" {
  target_id = "autoscaling-${local.aws_lambda_name}"
  rule = aws_cloudwatch_event_rule.autoscaling.name
  arn = aws_lambda_function.cloudwatch-dns-service.arn
  depends_on = [
    aws_lambda_function.cloudwatch-dns-service,
    aws_cloudwatch_event_rule.autoscaling,
  ]
}

resource "aws_lambda_permission" "cloudwatch-dns-service-autoscaling" {
  statement_id = "AllowExecutionFromCloudWatchAutoScaling"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch-dns-service.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.autoscaling.arn
  depends_on = [
    aws_lambda_function.cloudwatch-dns-service,
    aws_cloudwatch_event_rule.autoscaling,
  ]
}

resource "aws_cloudwatch_event_rule" "ec2" {
  name = "ec2-${local.aws_lambda_name}"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda-cloudwatch-dns-service-ec2" {
  target_id = "ec2-${local.aws_lambda_name}"
  rule      = aws_cloudwatch_event_rule.ec2.name
  arn       = aws_lambda_function.cloudwatch-dns-service.arn
  depends_on = [
    aws_lambda_function.cloudwatch-dns-service,
    aws_cloudwatch_event_rule.ec2,
  ]
}

resource "aws_lambda_permission" "cloudwatch-dns-service-ec2" {
  statement_id  = "AllowExecutionFromCloudWatchEC2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch-dns-service.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2.arn
  depends_on = [
    aws_lambda_function.cloudwatch-dns-service,
    aws_cloudwatch_event_rule.ec2,
  ]
}

