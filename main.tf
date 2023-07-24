data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "terrafrom instance"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name = "web"
  descreption = "security group creation "
  vpc_id = data.aws_vpc.default

  ingress {
    descreption = " allow http"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }

  ingress {
    descreption = " allow https"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }

  egress {
    descreption = " allow all"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
}