resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
      Name = "${var.project_name}-vpc"
    }
}

resource "aws_subnet" "subnet_private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
      Name = "${var.project_name}-private-subnet-${count.index + 1}"
    }
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.project_name}-db-security-group"
  description = "Security group for database"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "${var.project_name}-db-security-group"
    }
}