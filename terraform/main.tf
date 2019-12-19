provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "webservers_sg" {
  vpc_id = var.vpc_id
  name = "webserver_Sgroup"

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "dbservers_sg" {
  vpc_id = var.vpc_id
  name = "DBServer_Sgroup"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    security_groups = [aws_security_group.webservers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  count = 2
  ami           = "ami-087c2c50437d0b80d"
  instance_type = "t2.micro"
  key_name = var.keypair_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.webservers_sg.id]

  tags = {
    Name = "web"
    Terraform = "Yes"
    Env = "dev"
  }
}


resource "aws_instance" "db" {
  ami           = "ami-087c2c50437d0b80d"
  instance_type = "t2.micro"
  key_name = var.keypair_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.dbservers_sg.id]

  tags = {
    Name = "db"
    Terraform = "Yes"
    Env = "dev"
  }
}