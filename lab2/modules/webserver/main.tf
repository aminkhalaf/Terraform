#create a security group
resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  #inbound request for ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  #inbound request for machines
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #outbound request
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

    tags = {
      Name = "${var.env_prefix}-sg"
  }
} 

#AMI EC2 instance filter to get image ID
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# automate create key-pair with terraform
resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

#Create instance AMI EC2 
#we make here dynamic because ami id may change and we need to modify it here
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone

  #to access this instance from browser as well as via SSH
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

# This will start a shell script and run commands to update and install docker
# out file way
  user_data = file("entry-script.sh")

  tags = {
      Name = "${var.env_prefix}-server"
  }

}
