resource "aws_security_group" "web_sg" {
  name        = "travelmemory-web-sg"
  description = "Security group for TravelMemory web server"
  vpc_id      = aws_vpc.travelmemory_vpc.id

  ingress {
    description = "SSH only from administrator IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Temporary direct backend access"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "travelmemory-web-sg"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "travelmemory-database-sg"
  description = "Security group for private MongoDB server"
  vpc_id      = aws_vpc.travelmemory_vpc.id

  ingress {
    description     = "SSH from web server only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description     = "MongoDB from web server only"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow outbound traffic through NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "travelmemory-database-sg"
  }
}