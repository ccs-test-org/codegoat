resource "aws_subnet" "primary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_primary
  availability_zone = "${var.region}a"
  tags = {
    yor_trace = "1561271c-5ecc-42c7-9548-85d36edb0697"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_secondary
  availability_zone = "${var.region}c"
  tags = {
    yor_trace = "1f48e0d8-39df-4199-a257-27b9a14e2d25"
  }
}
