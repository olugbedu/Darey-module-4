# Terraform EC2 Module and Security Group Module with Apache2 UserData

This project demonstrates how to create modularized Terraform configurations for deploying an EC2 instance with a Security Group and Apache2 web server using UserData scripts.

## Project Overview

**Purpose:** Learn to use Terraform modules for creating reusable, modular infrastructure components that deploy an EC2 instance with Apache2 pre-configured.

**Key Learning Objectives:**
- Create reusable Terraform modules
- Configure EC2 instances through Terraform
- Implement Security Group modules
- Use UserData scripts for automated software installation

## Project Structure

```
terraform-ec2-apache/
├── README.md
├── main.tf
├── apache_userdata.sh
└── modules/
    ├── ec2/
    │   └── main.tf
    └── security_group/
        └── main.tf
```

## Getting Started

### Prerequisites

- AWS CLI installed and configured with appropriate credentials
- Terraform installed on your local machine
- Basic understanding of AWS EC2 and Security Groups

### Verify AWS Configuration
```bash
aws configure list
aws sts get-caller-identity
```

## Step-by-Step Implementation

### Step 1: Project Setup

1. **Create the main project directory:**
```bash
mkdir terraform-ec2-apache
cd terraform-ec2-apache
```

2. **Create the module directory structure:**
```bash
mkdir -p modules/ec2
mkdir -p modules/security_group
```

### Step 2: Create the Security Group Module

Create the Security Group module configuration:

```bash
nano modules/security_group/main.tf
```

**File Content:**
```hcl
# modules/security_group/main.tf
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Security Group"
  }
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}
```

### Step 3: Create the EC2 Module

Create the EC2 module configuration:

```bash
nano modules/ec2/main.tf
```

**File Content:**
```hcl
# modules/ec2/main.tf
variable "security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
  default     = ""
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  user_data             = var.user_data

  tags = {
    Name = "Apache Web Server"
  }
}

output "instance_id" {
  value = aws_instance.web_server.id
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
}
```

### Step 4: Create the UserData Script

Create the Apache2 installation script:

```bash
nano apache_userdata.sh
```

**File Content:**
```bash
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Hello World from $(hostname -f)/hi!" | sudo tee /var/www/html/index.html
```

**Make the script executable:**
```bash
chmod +x apache_userdata.sh
```

### Step 5: Create the Main Terraform Configuration

Create the main configuration file:

```bash
nano main.tf
```

**File Content:**
```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = ""
}

module "security_group" {
  source = "./modules/security_group"
}

module "ec2_instance" {
  source            = "./modules/ec2"
  security_group_id = module.security_group.security_group_id
  user_data         = file("apache_userdata.sh")
  key_name          = var.key_name
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2_instance.public_dns
}

output "apache_url" {
  description = "URL to access Apache web server"
  value       = "http://${module.ec2_instance.public_ip}"
}
```

### Step 6: Deploy the Infrastructure

1. **Initialize Terraform:**
```bash
terraform init
```

2. **Plan the deployment:**
```bash
terraform plan
```

3. **Apply the configuration:**
```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Step 7: Verify the Deployment

1. **Check the outputs:**
```bash
terraform output
```

2. **Access the web server:**
- Copy the `apache_url` from the output
- Open it in a web browser
- You should see: "Hello World from [hostname]/hi!"

3. **SSH into the instance (if key pair is configured):**
```bash
ssh -i /path/to/your-key.pem ec2-user@<public-ip>
```

4. **Verify Apache2 status:**
```bash
sudo systemctl status httpd
```

## Customization Options

### Variables You Can Modify

- **AWS Region:** Change the default region in `main.tf`
- **Instance Type:** Modify the `instance_type` variable in the EC2 module
- **Key Pair:** Add your EC2 key pair name for SSH access
- **Security Group Rules:** Customize ingress/egress rules in the security group module

### Example with Custom Variables

Create a `terraform.tfvars` file:
```hcl
aws_region = "us-west-2"
key_name   = "my-ec2-keypair"
```

## Cleanup

To avoid ongoing AWS charges, destroy the infrastructure when done:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

## Key Concepts Learned

1. **Terraform Modules:** Created reusable, modular infrastructure components
2. **Module Communication:** Used outputs from one module as inputs to another
3. **UserData Scripts:** Automated software installation and configuration
4. **Security Groups:** Configured network access rules for EC2 instances
5. **File Function:** Used Terraform's `file()` function to read external scripts

## Troubleshooting

**Common Issues:**

1. **Permission Denied on UserData Script:**
   - Ensure the script is executable: `chmod +x apache_userdata.sh`

2. **AWS Credentials Not Found:**
   - Run `aws configure` to set up your credentials

3. **Security Group Issues:**
   - Verify that ports 80 and 22 are open in the security group

4. **Website Not Accessible:**
   - Wait a few minutes for UserData script to complete
   - Check the EC2 instance status in AWS Console
   - Verify security group rules

## Additional Resources

- [Terraform Module Documentation](https://www.terraform.io/docs/modules/index.html)
- [AWS EC2 User Data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Contributing

This is a learning project. Feel free to experiment with additional features like:
- Auto Scaling Groups
- Load Balancers
- Multiple Availability Zones
- Custom VPC configuration

---

**Note:** This project is designed for educational purposes. Always follow AWS security best practices in production environments.