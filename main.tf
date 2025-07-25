provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

# Create a key pair resource
resource "aws_key_pair" "example_keypair" {
  key_name   = "example-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # Replace with the path to your public key file
}

# Create a security group
resource "aws_security_group" "example_sg" {
  name_prefix = "terraform-example-"

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "example_instance" {
  ami             = "ami-0c55b159cbfafe1d0" # Specify your desired AMI ID
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example_keypair.key_name
  security_groups = [aws_security_group.example_sg.name]

  # User data script to install and configure Apache
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "Terraform-Example-Instance"
  }
}
