# Terraform EC2 Instance with Key Pair and User Data

A comprehensive guide to deploying an EC2 instance on AWS using Terraform, including automated key pair generation and Apache HTTP server installation via user data scripts.

## Project Overview

This project demonstrates Infrastructure as Code (IaC) principles using Terraform to:
- Launch an EC2 instance on AWS
- Generate and manage SSH key pairs
- Execute user data scripts for server configuration
- Set up Apache HTTP server with a custom welcome page

## Learning Objectives

By completing this project, you will learn to:

1. **Terraform Configuration**: Write Terraform code to launch EC2 instances with specified configurations
2. **Key Pair Generation**: Generate SSH key pairs and make them available for secure instance access
3. **User Data Execution**: Execute initialization scripts on EC2 instances during launch

## Prerequisites

Before starting this project, ensure you have:

- AWS CLI installed and configured with appropriate credentials
- Terraform installed (version 0.12 or later)
- Basic understanding of AWS EC2 and Terraform concepts
- SSH key pair generated in your `~/.ssh/` directory

## Project Structure

```
terraform-ec2-keypair/
├── main.tf
├── README.md
└── outputs/ (generated after apply)
```

## Getting Started

### Task 1: Terraform Configuration for EC2 Instance

#### Step 1: Create Project Directory
```bash
mkdir terraform-ec2-keypair
cd terraform-ec2-keypair
```

#### Step 2: Create Terraform Configuration File
```bash
nano main.tf
```

#### Step 3: Add Terraform Configuration
Copy and paste the following configuration into your `main.tf` file:

```hcl
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

# Create a key pair resource
resource "aws_key_pair" "example_keypair" {
  key_name   = "example-keypair"
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
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
  ami             = "ami-0c55b159cbfafe1d0"  # Specify your desired AMI ID
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

# Output the public IP address
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example_instance.public_ip
}

# Output the public DNS name
output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.example_instance.public_dns
}
```

#### Step 4: Initialize Terraform
```bash
terraform init
```

#### Step 5: Plan the Deployment
```bash
terraform plan
```

#### Step 6: Apply the Configuration
```bash
terraform apply
```

When prompted, type `yes` to confirm the creation of resources.

### Task 2: User Data Script Execution

The user data script in the configuration above will:

1. **Update the system**: `yum update -y`
2. **Install Apache HTTP server**: `yum install -y httpd`
3. **Start Apache service**: `systemctl start httpd`
4. **Enable Apache to start on boot**: `systemctl enable httpd`
5. **Create a custom welcome page**: Echo HTML content to `/var/www/html/index.html`

The script executes automatically when the EC2 instance launches.

### Task 3: Accessing the Web Server

#### Step 1: Get the Public IP Address
After successful deployment, Terraform will output the public IP address:

```bash
# The output will show something like:
public_ip = "54.123.456.789"
public_dns = "ec2-54-123-456-789.compute-1.amazonaws.com"
```

#### Step 2: Access the Web Server
Open your web browser and navigate to:
```
http://[PUBLIC_IP_ADDRESS]
```

#### Step 3: Verify the Installation
You should see a page displaying:
```
Hello World from [instance-hostname]
```

## Verification Steps

### Check Instance Status
```bash
# View current Terraform state
terraform show

# Check specific resource
terraform state show aws_instance.example_instance
```

### SSH into the Instance (Optional)
```bash
ssh -i ~/.ssh/id_rsa ec2-user@[PUBLIC_IP_ADDRESS]
```

### Verify Apache Service
```bash
# Once connected via SSH
sudo systemctl status httpd
curl http://localhost
```

## Cleanup

To avoid ongoing AWS charges, destroy the resources when you're done:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction of resources.

## Important Notes

### AMI Selection
- The AMI ID `ami-0c55b159cbfafe1d0` is an example and may not be available in all regions
- Use the AWS Console or CLI to find appropriate AMI IDs for your region:
```bash
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query 'Images[*].[ImageId,Name]' --output table
```

### Security Considerations
- The security group allows SSH and HTTP access from anywhere (`0.0.0.0/0`)
- In production, restrict access to specific IP ranges
- Consider using AWS Systems Manager Session Manager instead of direct SSH

### Cost Management
- t2.micro instances are eligible for AWS Free Tier
- Remember to destroy resources after testing to avoid charges

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Configure AWS credentials
   aws configure
   ```

2. **AMI Not Found**
   - Update the AMI ID for your specific region
   - Ensure the AMI is available in your selected region

3. **Key Pair Issues**
   - Verify your public key path is correct
   - Ensure the key pair doesn't already exist in AWS

4. **Security Group Conflicts**
   - Use unique security group names
   - Check for existing security groups with similar names

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html)

## Project Completion Checklist

- [ ] Created project directory and main.tf file
- [ ] Successfully ran `terraform init`
- [ ] Applied configuration with `terraform apply`
- [ ] Verified EC2 instance creation in AWS Console
- [ ] Accessed web server via public IP
- [ ] Confirmed "Hello World" message displays
- [ ] Documented any challenges or observations
- [ ] Cleaned up resources with `terraform destroy`

---

**Learning Exercise**: This project serves as a hands-on introduction to Terraform and AWS infrastructure automation. Use it to build confidence with Infrastructure as Code practices.