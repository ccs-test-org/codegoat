resource "aws_vpc" "example" {
  cidr_block = var.cidr
  tags = {
    yor_trace = "0d1fbbd3-a82d-452c-bc38-3d4995f1743f"
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
    yor_trace = "c985b236-a62b-4edc-8240-5359ee73a2d5"
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
    yor_trace = "549d0985-4b12-4a71-b9f6-8f40a028d08e"
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
    yor_trace = "1f2ff477-7b51-47ec-a40a-8057e0846bd4"
  }
}
