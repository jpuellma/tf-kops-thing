provider "aws" {
  region = "${var.region}"
}


// kops group
resource "aws_iam_group" "kops" {
  name = "kops"
}


// group policy attachments for kops group
resource "aws_iam_group_policy_attachment" "AmazonEC2FullAccess" {
  group = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonRoute53FullAccess" {
  group = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonS3FullAccess" {
  group = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonVPCFullAccess" {
  group = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "IAMFullAccess" {
    group = "${aws_iam_group.kops.name}"
    policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}


// kops user
resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_group_membership" "kops" {
  name = "kops-group-membership"
  users = ["${aws_iam_user.kops.name}"]
  group = "${aws_iam_group.kops.name}"
}

resource "aws_iam_access_key" "kops" {
  user = "${aws_iam_user.kops.name}"
}


// S3 Storage for cluster state
resource "aws_s3_bucket" "cluster-state-store" {
  bucket = "${var.cluster_name}-jpuellma-net-state-store"
  acl    = "private"
  region = "${var.region}"

  tags {
    Name        = "Cluster State Store Bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}
