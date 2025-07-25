# Terraform Modules: VPC and S3 Bucket with Backend Storage

## Project Overview

This project demonstrates how to create modularized Terraform configurations for building AWS infrastructure, specifically an Amazon Virtual Private Cloud (VPC) and an Amazon S3 bucket. The project also configures Terraform to use Amazon S3 as the backend storage for storing the Terraform state file.

## Learning Objectives

- Create and use Terraform modules for modular infrastructure provisioning
- Build a reusable Terraform module for VPC creation with customizable configurations
- Develop a Terraform module for S3 bucket creation with customizable settings
- Configure Terraform to use Amazon S3 as backend storage for state management

## Prerequisites

Before starting this project, ensure you have:

- AWS CLI installed and configured with appropriate credentials
- Terraform installed on your local machine
- Basic understanding of AWS services (VPC, S3)
- Text editor or IDE for writing Terraform configurations

## Project Structure

```
terraform-modules-vpc-s3/
├── main.tf
├── backend.tf
├── variables.tf (optional)
├── outputs.tf (optional)
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Implementation Steps

### Step 1: Project Setup

1. **Create the main project directory:**
   ```bash
   mkdir terraform-modules-vpc-s3
   cd terraform-modules-vpc-s3
   ```

2. **Create module directories:**
   ```bash
   mkdir -p modules/vpc
   mkdir -p modules/s3
   ```

### Step 2: VPC Module Creation

1. **Create the VPC module configuration:**
   ```bash
   nano modules/vpc/main.tf
   ```

2. **VPC Module Content (`modules/vpc/main.tf`):**
   ```hcl
   # VPC Resource
   resource "aws_vpc" "main" {
     cidr_block           = var.vpc_cidr
     enable_dns_hostnames = var.enable_dns_hostnames
     enable_dns_support   = var.enable_dns_support
     
     tags = {
       Name = var.vpc_name
     }
   }

   # Internet Gateway
   resource "aws_internet_gateway" "main" {
     vpc_id = aws_vpc.main.id
     
     tags = {
       Name = "${var.vpc_name}-igw"
     }
   }

   # Public Subnet
   resource "aws_subnet" "public" {
     count                   = length(var.public_subnet_cidrs)
     vpc_id                  = aws_vpc.main.id
     cidr_block              = var.public_subnet_cidrs[count.index]
     availability_zone       = var.availability_zones[count.index]
     map_public_ip_on_launch = true
     
     tags = {
       Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
     }
   }

   # Route Table for Public Subnets
   resource "aws_route_table" "public" {
     vpc_id = aws_vpc.main.id
     
     route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.main.id
     }
     
     tags = {
       Name = "${var.vpc_name}-public-rt"
     }
   }

   # Route Table Association
   resource "aws_route_table_association" "public" {
     count          = length(aws_subnet.public)
     subnet_id      = aws_subnet.public[count.index].id
     route_table_id = aws_route_table.public.id
   }
   ```

3. **Create VPC module variables (`modules/vpc/variables.tf`):**
   ```hcl
   variable "vpc_name" {
     description = "Name of the VPC"
     type        = string
     default     = "main-vpc"
   }

   variable "vpc_cidr" {
     description = "CIDR block for VPC"
     type        = string
     default     = "10.0.0.0/16"
   }

   variable "public_subnet_cidrs" {
     description = "CIDR blocks for public subnets"
     type        = list(string)
     default     = ["10.0.1.0/24", "10.0.2.0/24"]
   }

   variable "availability_zones" {
     description = "Availability zones"
     type        = list(string)
     default     = ["us-east-1a", "us-east-1b"]
   }

   variable "enable_dns_hostnames" {
     description = "Enable DNS hostnames in VPC"
     type        = bool
     default     = true
   }

   variable "enable_dns_support" {
     description = "Enable DNS support in VPC"
     type        = bool
     default     = true
   }
   ```

4. **Create VPC module outputs (`modules/vpc/outputs.tf`):**
   ```hcl
   output "vpc_id" {
     description = "ID of the VPC"
     value       = aws_vpc.main.id
   }

   output "vpc_cidr_block" {
     description = "CIDR block of the VPC"
     value       = aws_vpc.main.cidr_block
   }

   output "public_subnet_ids" {
     description = "IDs of the public subnets"
     value       = aws_subnet.public[*].id
   }

   output "internet_gateway_id" {
     description = "ID of the Internet Gateway"
     value       = aws_internet_gateway.main.id
   }
   ```

### Step 3: S3 Bucket Module Creation

1. **Create the S3 module configuration:**
   ```bash
   nano modules/s3/main.tf
   ```

2. **S3 Module Content (`modules/s3/main.tf`):**
   ```hcl
   # S3 Bucket
   resource "aws_s3_bucket" "main" {
     bucket = var.bucket_name
     
     tags = var.tags
   }

   # S3 Bucket Versioning
   resource "aws_s3_bucket_versioning" "main" {
     bucket = aws_s3_bucket.main.id
     versioning_configuration {
       status = var.versioning_enabled ? "Enabled" : "Disabled"
     }
   }

   # S3 Bucket Server Side Encryption
   resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
     bucket = aws_s3_bucket.main.id

     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
       }
     }
   }

   # S3 Bucket Public Access Block
   resource "aws_s3_bucket_public_access_block" "main" {
     bucket = aws_s3_bucket.main.id

     block_public_acls       = var.block_public_access
     block_public_policy     = var.block_public_access
     ignore_public_acls      = var.block_public_access
     restrict_public_buckets = var.block_public_access
   }
   ```

3. **Create S3 module variables (`modules/s3/variables.tf`):**
   ```hcl
   variable "bucket_name" {
     description = "Name of the S3 bucket"
     type        = string
   }

   variable "versioning_enabled" {
     description = "Enable versioning for S3 bucket"
     type        = bool
     default     = true
   }

   variable "block_public_access" {
     description = "Block all public access to S3 bucket"
     type        = bool
     default     = true
   }

   variable "tags" {
     description = "Tags to apply to the S3 bucket"
     type        = map(string)
     default     = {}
   }
   ```

4. **Create S3 module outputs (`modules/s3/outputs.tf`):**
   ```hcl
   output "bucket_id" {
     description = "ID of the S3 bucket"
     value       = aws_s3_bucket.main.id
   }

   output "bucket_arn" {
     description = "ARN of the S3 bucket"
     value       = aws_s3_bucket.main.arn
   }

   output "bucket_domain_name" {
     description = "Domain name of the S3 bucket"
     value       = aws_s3_bucket.main.bucket_domain_name
   }
   ```

### Step 4: Main Configuration

1. **Create the main Terraform configuration:**
   ```bash
   nano main.tf
   ```

2. **Main Configuration Content (`main.tf`):**
   ```hcl
   # Configure AWS Provider
   provider "aws" {
     region = var.aws_region
   }

   # VPC Module
   module "vpc" {
     source = "./modules/vpc"
     
     vpc_name             = var.vpc_name
     vpc_cidr             = var.vpc_cidr
     public_subnet_cidrs  = var.public_subnet_cidrs
     availability_zones   = var.availability_zones
   }

   # S3 Bucket Module
   module "s3_bucket" {
     source = "./modules/s3"
     
     bucket_name         = var.bucket_name
     versioning_enabled  = var.versioning_enabled
     block_public_access = var.block_public_access
     
     tags = {
       Name        = var.bucket_name
       Environment = var.environment
       Project     = "terraform-modules-demo"
     }
   }
   ```

### Step 5: Backend Storage Configuration

1. **Create the backend configuration:**
   ```bash
   nano backend.tf
   ```

2. **Backend Configuration Content (`backend.tf`):**
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "your-terraform-state-bucket"  # Replace with your bucket name
       key            = "terraform.tfstate"
       region         = "us-east-1"                    # Change to your desired region
       encrypt        = true
       dynamodb_table = "your-lock-table"              # Replace with your DynamoDB table
     }
   }
   ```

### Step 6: Variables and Outputs

1. **Create main variables file (`variables.tf`):**
   ```hcl
   variable "aws_region" {
     description = "AWS region"
     type        = string
     default     = "us-east-1"
   }

   variable "vpc_name" {
     description = "Name of the VPC"
     type        = string
     default     = "demo-vpc"
   }

   variable "vpc_cidr" {
     description = "CIDR block for VPC"
     type        = string
     default     = "10.0.0.0/16"
   }

   variable "public_subnet_cidrs" {
     description = "CIDR blocks for public subnets"
     type        = list(string)
     default     = ["10.0.1.0/24", "10.0.2.0/24"]
   }

   variable "availability_zones" {
     description = "Availability zones"
     type        = list(string)
     default     = ["us-east-1a", "us-east-1b"]
   }

   variable "bucket_name" {
     description = "Name of the S3 bucket"
     type        = string
     default     = "my-terraform-demo-bucket-12345"  # Must be globally unique
   }

   variable "versioning_enabled" {
     description = "Enable versioning for S3 bucket"
     type        = bool
     default     = true
   }

   variable "block_public_access" {
     description = "Block all public access to S3 bucket"
     type        = bool
     default     = true
   }

   variable "environment" {
     description = "Environment name"
     type        = string
     default     = "development"
   }
   ```

2. **Create main outputs file (`outputs.tf`):**
   ```hcl
   output "vpc_id" {
     description = "ID of the VPC"
     value       = module.vpc.vpc_id
   }

   output "public_subnet_ids" {
     description = "IDs of the public subnets"
     value       = module.vpc.public_subnet_ids
   }

   output "s3_bucket_id" {
     description = "ID of the S3 bucket"
     value       = module.s3_bucket.bucket_id
   }

   output "s3_bucket_arn" {
     description = "ARN of the S3 bucket"
     value       = module.s3_bucket.bucket_arn
   }
   ```

## Deployment Steps

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Validate Configuration
```bash
terraform validate
```

### 3. Plan the Deployment
```bash
terraform plan
```

### 4. Apply the Configuration
```bash
terraform apply
```

### 5. Confirm Resource Creation
Review the output and type `yes` when prompted to confirm the creation of resources.

## Verification

After successful deployment, verify the created resources:

1. **Check VPC in AWS Console:**
   - Navigate to VPC service
   - Verify the VPC, subnets, and internet gateway are created

2. **Check S3 Bucket in AWS Console:**
   - Navigate to S3 service
   - Verify the bucket is created with proper configuration

3. **Check Terraform State:**
   ```bash
   terraform show
   terraform state list
   ```

## Cleanup

To destroy the infrastructure when no longer needed:

```bash
terraform destroy
```

## Important Notes

- **Bucket Names**: S3 bucket names must be globally unique. Update the `bucket_name` variable accordingly.
- **AWS Credentials**: Ensure your AWS CLI is configured with appropriate permissions.
- **Backend Setup**: Before using S3 backend, create the state bucket and DynamoDB table manually.
- **Region Configuration**: Update the AWS region in both provider and backend configurations as needed.
- **Security**: Follow AWS security best practices for production deployments.

## Troubleshooting

### Common Issues:

1. **Bucket Already Exists**: Choose a unique bucket name
2. **Permission Denied**: Check AWS credentials and IAM permissions
3. **Backend Initialization**: Ensure the backend S3 bucket exists before running `terraform init`

### Useful Commands:

```bash
# Format Terraform files
terraform fmt

# Validate syntax
terraform validate

# Show current state
terraform show

# List all resources
terraform state list

# Get specific output
terraform output vpc_id
```

## Learning Outcomes

By completing this project, you have learned:

- ✅ How to structure Terraform projects with modules
- ✅ Creating reusable infrastructure components
- ✅ Managing Terraform state with remote backends
- ✅ Best practices for variable and output management
- ✅ Implementing AWS VPC and S3 bucket infrastructure as code

## Next Steps

- Explore additional AWS services and create more modules
- Implement CI/CD pipelines for Terraform deployments
- Study Terraform workspaces for environment management
- Learn about Terraform Cloud for team collaboration