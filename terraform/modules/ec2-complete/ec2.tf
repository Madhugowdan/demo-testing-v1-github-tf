resource "aws_instance" "windows_stage_ec2" {
  ami                    = data.aws_ami.windows.id
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = local.comman_tags

  credit_specification {
    cpu_credits = "unlimited"
  }
}

locals {
  comman_tags = {
    Owner   = " Dev Team"
    service = "backend"
    Name    = "windows-ec2"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.network_cidr
  instance_tenancy = "default"
  tags = {
    Name = "stage"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.sub_availability_zone

  tags = {
    Name = "stage"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = aws_subnet.my_subnet.id
  # private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_ebs_volume" "ebs_volume_for_windows_ec2" {
  availability_zone = var.sub_availability_zone
  size              = 80
  tags              = local.comman_tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_volume_for_windows_ec2.id
  instance_id = aws_instance.windows_stage_ec2.id
}

data "aws_ami" "windows" {
  most_recent = true
  #owners = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }
  owners = ["801119661308"] # Canonical
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.sg_ports_ingress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.my_vpc.cidr_block]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports_egress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.my_vpc.cidr_block]
    }
  }

  tags = {
    Name = "allow_tls"
  }
}