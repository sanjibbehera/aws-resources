# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEV_ROOT/DYNAMODB/DB.TF FILE
# Author : SANJIB BEHERA
# Version: SB_0.1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_dynamodb_table_item" "table_item1" {
  table_name = aws_dynamodb_table.basic-dynamodb-table.name
  hash_key   = aws_dynamodb_table.basic-dynamodb-table.hash_key
  item = <<ITEM
{
    "ProductId": {"S": "productid101"},
    "ProductName": {"S": "Cricket Bat"},
    "ProductCount": {"N": "20"},
    "ProductPrice": {"N": "120"},
    "ProductCategory": {"S": "Sports"}
}
ITEM
}

resource "aws_dynamodb_table_item" "table_item2" {
  table_name = aws_dynamodb_table.basic-dynamodb-table.name
  hash_key   = aws_dynamodb_table.basic-dynamodb-table.hash_key
  item = <<ITEM
{
    "ProductId": {"S": "productid102"},
    "ProductName": {"S": "Tennis Bat"},
    "ProductCount": {"N": "20"},
    "ProductPrice": {"N": "7000"},
    "ProductCategory": {"S": "Sports"}
}
ITEM
}

resource "aws_dynamodb_table_item" "table_item3" {
  table_name = aws_dynamodb_table.basic-dynamodb-table.name
  hash_key   = aws_dynamodb_table.basic-dynamodb-table.hash_key
  item = <<ITEM
{
    "ProductId": {"S": "productid103"},
    "ProductName": {"S": "TT Bat"},
    "ProductCount": {"N": "20"},
    "ProductPrice": {"N": "1200"},
    "ProductCategory": {"S": "Sports"}
}
ITEM
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  read_capacity  = var.rcu
  write_capacity = var.wcu
  hash_key       = var.hash_key

  attribute {
    name = "ProductId"
    type = "S"
  }

  tags = {
    Name        = "sanjib-dynamodb-table"
    Environment = "terraform-sanjib"
  }

}