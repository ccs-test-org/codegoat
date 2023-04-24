resource "aws_vpc" "example" {
  cidr_block = var.cidr
  tags = {
    yor_trace = "452d69d7-550f-4d00-8cdd-3e76b66bd66c"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.example.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  tags = {
    yor_trace = "e3fc63d4-4985-4b26-96d8-95a9575c6a8e"
  }
}

resource "aws_security_group" "allow_all_ssh" {
  name        = "allow_all_ssh"
  description = "Allow SSH inbound from anywhere"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    yor_trace = "e8cb6757-78f5-46c7-828a-90fd0b1f168d"
  }
}

resource "aws_security_group" "allow_ssh_from_valid_cidr" {
  name        = "allow_ssh_from_valid_cidr"
  description = "Allow SSH inbound from specific range"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = tolist([var.cidr])
  }
  tags = {
    yor_trace = "52de85b6-647d-406e-8380-bc23e4b5f292"
  }
}
