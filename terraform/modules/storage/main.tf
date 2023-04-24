resource "aws_db_subnet_group" "example_rds_subnet_grp" {
  name       = "example_rds_subnet_grp_${var.environment}"
  subnet_ids = var.private_subnet

  tags = merge(var.default_tags, {
    Name = "example_rds_subnet_grp_${var.environment}"
    }, {
    yor_trace = "a30a64f3-0f23-4a02-a802-46269fa67eba"
  })
}

resource "aws_security_group" "example_rds_sg" {
  name   = "example_rds_sg"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, {
    Name = "example_rds_sg_${var.environment}"
    }, {
    yor_trace = "069eb5a0-4a89-4cef-aaa6-fe200c1cfe9c"
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
    yor_trace = "e708fa68-725e-429a-b167-59f236e5727a"
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
    yor_trace = "f63301d8-a964-4cad-b16a-e760b4e96da0"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_host" {
  name        = "/example-${var.environment}/DB_HOST"
  description = "example Database"
  type        = "String"
  value       = aws_db_instance.example_db.endpoint

  tags = merge(var.default_tags, {}, {
    yor_trace = "8ee0ae5f-fe11-46d8-a30a-bff4a6258ea2"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_password" {
  name        = "/example-${var.environment}/DB_PASSWORD"
  description = "example Database Password"
  type        = "String"
  value       = aws_db_instance.example_db.password

  tags = merge(var.default_tags, {}, {
    yor_trace = "b2be43d4-32bc-4aee-8f06-cbc6ac6172a8"
  })
}

resource "aws_ssm_parameter" "example_ssm_db_user" {
  name        = "/example-${var.environment}/DB_USER"
  description = "example Database Username"
  type        = "String"
  value       = aws_db_instance.example_db.username

  tags = merge(var.default_tags, {}, {
    yor_trace = "146cc0b5-07df-47ba-9c2f-73a62940cf6d"
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
    yor_trace = "4c62d833-855e-42ab-aaea-649492686b8c"
  })
}

resource "aws_s3_bucket" "my-private-bucket" {
  bucket = "my-private-bucket-demo"

  tags = merge(var.default_tags, {
    name = "example_private_${var.environment}"
    }, {
    yor_trace = "2c86d55d-e78c-4c9b-9de6-9a79c0fd8afa"
  })
}

resource "aws_s3_bucket" "public-bucket-oops" {
  bucket = "my-public-bucket-oops-demo"

  tags = merge(var.default_tags, {
    name = "example_public_${var.environment}"
    }, {
    yor_trace = "6001c6c8-29f7-4121-84fe-161a563266f8"
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
