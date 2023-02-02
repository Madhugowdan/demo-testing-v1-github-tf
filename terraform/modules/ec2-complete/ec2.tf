data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}
data "aws_subnet" "existing" {
  filter {
    name   = "tag:Name"
    values = var.subnet_name_1
  }

}


data "aws_ami" "windows" {
  most_recent = true
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
  vpc_id      = data.aws_vpc.existing.id

  dynamic "ingress" {
    for_each = var.sg_ports_ingress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.existing.cidr_block]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports_egress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.existing.cidr_block]
    }
  }
  tags = {
    Name = "allow_tls"
  }
}



resource "aws_instance" "windows_ec2" {
  count                  = var.instance_count
  ami                    = data.aws_ami.windows.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.existing.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  root_block_device {
    volume_size = var.root_volum
  }
  tags = {
    Name = "${var.instance_name_prefix}-${count.index}"
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
}


resource "aws_ebs_volume" "ebs_volume_for_windows_ec2" {
  count             = var.instance_count
  availability_zone = data.aws_subnet.existing.availability_zone
  size              = var.ebs_size
  depends_on        = [aws_instance.windows_ec2]

}
resource "aws_volume_attachment" "ebs_att" {
  count       = var.instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_volume_for_windows_ec2[count.index].id
  instance_id = aws_instance.windows_ec2[count.index].id

}