
output "aws_iam_group.kops details" {
  value = {
    arn = "${aws_iam_group.kops.arn}"
    id = "${aws_iam_group.kops.id}"
    name = "${aws_iam_group.kops.name}"
    unique_id = "${aws_iam_group.kops.unique_id}"
  }
}

