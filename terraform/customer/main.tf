# create S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.service_name
  tags = {
    Environment = var.environment
  }
}

# create RDS MySQL instance
resource "aws_db_instance" "rds_instance" {
  identifier            = "${var.service_name}-db"
  instance_class        = var.rds_instance_class
  engine                = "mysql"
  engine_version        = "5.7"
  db_name               = var.db_name
  username              = var.rds_username
  password              = var.rds_password
  parameter_group_name  = "default.mysql5.7"
  allocated_storage     = 20

  tags = {
    Environment = var.environment
  }
}

# create IAM role with full access to S3 bucket and RDS MySQL instance
resource "aws_iam_role" "iam_role" {
  name = "${var.service_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# create IAM policy with full access to S3 bucket and RDS MySQL instance
resource "aws_iam_policy" "iam_policy" {
  name_prefix = "${var.service_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "rds:*"
        ]
        Resource = [
          aws_db_instance.rds_instance.arn
        ]
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.iam_policy.arn
  role       = aws_iam_role.iam_role.name
}

# Create SSM parameters for the S3 bucket, RDS credentials and URL
resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/services/${var.service_name}/s3_bucket_name"
  value = aws_s3_bucket.s3_bucket.id
  type  = "String"
}

resource "aws_ssm_parameter" "rds_host" {
  name  = "/services/${var.service_name}/rds_host"
  value = aws_db_instance.rds_instance.endpoint
  type  = "String"
}

resource "aws_ssm_parameter" "rds_username" {
  name  = "/services/${var.service_name}/rds_username"
  value = aws_db_instance.rds_instance.username
  type  = "SecureString"
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/services/${var.service_name}/rds_password"
  value = aws_db_instance.rds_instance.password
  type  = "SecureString"
}
#
# output RDS URL
output "rds_url" {
  value = aws_db_instance.rds_instance.endpoint
}

# output IAM Role Name
output "iam_role_name" {
  value = aws_iam_role.iam_role.name
}

# output S3 Bucket Name
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

