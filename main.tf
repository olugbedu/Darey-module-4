provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# Create EC2 Instance
resource "aws_instance" "my_ec2_spec" {
  ami           = "ami-0c55b159cbfafe1d0" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"              # Free tier eligible instance type

  tags = {
    Name        = "Terraform-created-EC2-instance"
    Environment = "Learning"
    Project     = "Terraform-AMI-Creation"
  }
}

# Create AMI from EC2 Instance
resource "aws_ami" "my_ec2_spec_ami" {
  name               = "my-ec2-ami"
  description        = "My AMI created from my EC2 instance with Terraform script"
  source_instance_id = aws_instance.my_ec2_spec.id

  tags = {
    Name        = "Terraform-created-AMI"
    Environment = "Learning"
    Project     = "Terraform-AMI-Creation"
  }
}

