resource "aws_subnet" "primary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_primary
  availability_zone = "${var.region}a"
  tags = {
    yor_trace = "e8f8600d-0ac8-44b4-b04e-70fcad526da8"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_secondary
  availability_zone = "${var.region}c"
  tags = {
    yor_trace = "f50388c1-67cc-4002-8fd6-67a9fdbebe5d"
  }
}
