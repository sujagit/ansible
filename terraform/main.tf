provider "aws" {
    region = "us-east-1"
  
}

resource "aws_vpc" "myapp_vpc" {

    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    tags = {
        Name: "${var.env}-vpc"
    }
  
}

resource "aws_subnet" "myapp_subnet1" {

    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.subnet_1_cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name: "${var.env}-subnet-1"
    }
  
}

resource "aws_internet_gateway" "myapp_igw" {
    vpc_id = aws_vpc.myapp_vpc.id
    tags = {
        Name: "${var.env}-igw"
    } 
  
}

resource "aws_route_table" "myapp_route_table" {
    vpc_id = aws_vpc.myapp_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp_igw.id
    }
    tags = {
        Name: "${var.env}-route_table"
    } 
}

resource "aws_route_table_association" "rt-subnet" {
    subnet_id = aws_subnet.myapp_subnet1.id
    route_table_id = aws_route_table.myapp_route_table.id
  
}

resource "aws_security_group" "myapp_sg" {
    vpc_id = aws_vpc.myapp_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.local_ip,var.jenkins_ip,var.ansible_ip]
    }
    
    
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = [ ]

    }

    tags = {
        Name: "${var.env}-sg"
    } 
}

data "aws_ami" "latest-amazon-linux-image"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

resource "aws_key_pair" "myapp_key_pair" {
  key_name = "ssh-key"
  public_key = file(var.ssh-key)
}

resource "aws_instance" "myapp_instance_1" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp_subnet1.id
    vpc_security_group_ids = [aws_security_group.myapp_sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.myapp_key_pair.key_name
     tags = {
        Name: "${var.env}-instance_1"
    }
}

resource "aws_instance" "myapp_instance_2" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp_subnet1.id
    vpc_security_group_ids = [aws_security_group.myapp_sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.myapp_key_pair.key_name
     tags = {
        Name: "${var.env}-instance_2"
    }
}


output "instance_ip_1" {
    value = aws_instance.myapp_instance_1.public_ip
  
}
output "instance_ip_2" {
    value = aws_instance.myapp_instance_2.public_ip
  
}

