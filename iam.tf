resource "aws_iam_role" "default" {
  name = local.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "default" {
  name = local.name
  role = aws_iam_role.default.name
  depends_on = [aws_iam_role.default]
}

resource "aws_iam_role_policy" "default" {
  name = local.name
  role = aws_iam_role.default.name
  depends_on = [aws_iam_role.default]

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAddresses",
        "ec2:DescribeInstances",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumeStatus",
        "ec2:AttachVolume",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "*"
    },
    {   
      "Effect":"Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],  
      "Resource": [
        "arn:aws:route53:::hostedzone/${local.aws_route53_zone_id}"
      ]
    }
  ]
}
EOF

}
