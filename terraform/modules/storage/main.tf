resource "aws_db_subnet_group" "example_rds_subnet_grp" {
  name       = "example_rds_subnet_grp_${var.environment}"
  subnet_ids = var.private_subnet

  tags = merge(var.default_tags, {
    Name = "example_rds_subnet_grp_${var.environment}"
    }, {
    yor_trace = "ad51da99-b1fd-4828-be78-8b08c856da68"
  })
}

resource "aws_security_group" "example_rds_sg" {
  name   = "example_rds_sg"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, {
    Name = "example_rds_sg_${var.environment}"
    }, {
    yor_trace = "50f77602-6164-47bf-8fc4-aa08f525615e"
  })

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "example_db_kms_key" {
  description             = "KMS Key for DB instance ${var.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge(var.default_tags, {
    Name = "example_db_kms_key_${var.environment}"
    }, {
    yor_trace = "065b91af-3c2a-4707-a7be-491cbc695d10"
  })
}

resource "aws_db_instance" "example_db" {
  db_name                   = "example_db_${var.environment}"
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "10.20"
  instance_class            = "db.t3.micro"
  storage_type              = "gp2"
  password                  = var.db_password
  username                  = var.db_username
  vpc_security_group_ids    = [aws_security_group.example_rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.example_rds_subnet_grp.id
  identifier                = "example-db-${var.environment}"
  storage_encrypted         = true
  skip_final_snapshot       = true
  final_snapshot_identifier = "example-db-${var.environment}-db-destroy-snapshot"
  kms_key_id                = aws_kms_key.example_db_kms_key.arn
  tags = merge(var.default_tags, {
    Name = "example_db_${var.environment}"
    }, {
    yor_trace = "e22dcb81-169e-4a40-8602-f01ac19c7009"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_host" {
  name        = "/example-${var.environment}/DB_HOST"
  description = "example Database"
  type        = "String"
  value       = aws_db_instance.example_db.endpoint

  tags = merge(var.default_tags, {}, {
    yor_trace = "aa0068b3-e637-438b-be33-7ff5393d9adb"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_password" {
  name        = "/example-${var.environment}/DB_PASSWORD"
  description = "example Database Password"
  type        = "String"
  value       = aws_db_instance.example_db.password

  tags = merge(var.default_tags, {}, {
    yor_trace = "b585e990-80eb-4641-bf47-ae7f8b366cdb"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_user" {
  name        = "/example-${var.environment}/DB_USER"
  description = "example Database Username"
  type        = "String"
  value       = aws_db_instance.example_db.username

  tags = merge(var.default_tags, {}, {
    yor_trace = "92716336-adeb-448b-abaa-52da2e9eb443"
  })
}
resource "aws_ssm_parameter" "example_ssm_db_name" {
  name        = "/example-${var.environment}/DB_NAME"
  description = "example Database Name"
  type        = "String"
  value       = aws_db_instance.example_db.name

  tags = merge(var.default_tags, {
    environment = "${var.environment}"
    }, {
    yor_trace = "3d2e156f-8de6-44a0-8feb-32a328633aef"
  })
}

resource "aws_s3_bucket" "my-private-bucket" {
  bucket = "my-private-bucket-demo"

  tags = merge(var.default_tags, {
    name = "example_private_${var.environment}"
    }, {
    yor_trace = "fa78d0fc-ca92-4a2e-a55c-dd520ea8fd28"
  })
}

resource "aws_s3_bucket" "public-bucket-oops" {
  bucket = "my-public-bucket-oops-demo"

  tags = merge(var.default_tags, {
    name = "example_public_${var.environment}"
    }, {
    yor_trace = "1edacc78-128b-4a27-9a65-c3a39cc7005f"
  })
}

resource "aws_s3_bucket_public_access_block" "private_access" {
  bucket = aws_s3_bucket.my-private-bucket.id

  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.public-bucket-oops.id

  ignore_public_acls      = var.public_var
  block_public_acls       = var.public_var
  block_public_policy     = var.public_var
  restrict_public_buckets = var.public_var
}

resource "aws_s3_bucket_acl" "private_access_acl" {
  bucket = aws_s3_bucket.my-private-bucket.id

  acl = var.acl
}

resource "aws_s3_bucket_acl" "public_access_acl" {
  bucket = aws_s3_bucket.public-bucket-oops.id

  acl = var.acl
}
