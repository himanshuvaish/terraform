output "dynamodb" {
  value = "${aws_dynamodb_table.sessioninformation.id}"
}
