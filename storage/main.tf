resource "aws_dynamodb_table" "sessioninformation" {
  name           = "session-information"
  hash_key       = "SessionID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "SessionID"
    type = "S"
  }

  tags {
    Name = "SessionIDTable"
  }
}
