# Terraform Capstone Project: Automated WordPress Deployment on AWS

## Project Overview

This project demonstrates the implementation of a scalable, secure, and cost-effective WordPress hosting solution on AWS using Terraform Infrastructure as Code (IaC). The solution is designed for DigitalBoost, a digital marketing agency requiring a high-performance WordPress website with automated deployment capabilities.

## Architecture Overview

The infrastructure spans across 2 Availability Zones for high availability and includes:
- VPC with public and private subnets
- Internet Gateway and NAT Gateway
- Application Load Balancer
- Auto Scaling Group with EC2 instances
- Amazon RDS MySQL database
- Amazon EFS for shared file storage
- Route 53 for DNS management
- Comprehensive security groups

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 0.12+)
- Knowledge of TechOps Essentials
- Completion of Core 2 Courses and Mini Projects
- Basic understanding of AWS services and networking concepts

## Project Structure

```
terraform-wordpress/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   ├── rds/
│   ├── efs/
│   ├── alb/
│   └── autoscaling/
└── scripts/
    └── user-data.sh
```

## Implementation Steps

### Step 1: VPC Setup

**Objective:** Create a Virtual Private Cloud (VPC) to isolate and secure the WordPress infrastructure.

**Tasks Completed:**
1. Define IP address range for the VPC (10.0.0.0/16)
2. Create VPC with public and private subnets across 2 AZs
3. Configure route tables for each subnet type

**Terraform Components:**
```hcl
# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "wordpress-vpc"
  }
}
```

**Key Features:**
- Multi-AZ deployment for high availability
- Separate public and private subnets
- DNS resolution enabled

### Step 2: Public and Private Subnets with NAT Gateway

**Objective:** Implement secure network architecture with NAT Gateway for private subnet internet access.

**Tasks Completed:**
1. Created public subnets in 2 AZs for internet-facing resources
2. Created private subnets in 2 AZs for application and database tiers
3. Deployed NAT Gateway in public subnet for outbound internet access
4. Configured route tables with appropriate associations

**Terraform Components:**
```hcl
# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}
```

**Network Flow:**
- Public subnets → Internet Gateway → Internet
- Private subnets → NAT Gateway → Internet Gateway → Internet

### Step 3: Security Groups Configuration

**Objective:** Implement layered security with specific security groups for each tier.

**Security Groups Created:**
1. **ALB Security Group**
   - Inbound: HTTP (80) and HTTPS (443) from 0.0.0.0/0
   - Outbound: All traffic

2. **SSH Security Group**
   - Inbound: SSH (22) from your IP address
   - Purpose: Bastion host access

3. **Webserver Security Group**
   - Inbound: HTTP/HTTPS from ALB Security Group
   - Inbound: SSH from SSH Security Group
   - Purpose: EC2 instances running WordPress

4. **Database Security Group**
   - Inbound: MySQL (3306) from Webserver Security Group
   - Purpose: RDS MySQL instance

5. **EFS Security Group**
   - Inbound: NFS (2049) from Webserver and EFS Security Groups
   - Inbound: SSH from SSH Security Group
   - Purpose: Elastic File System access

### Step 4: AWS MySQL RDS Setup

**Objective:** Deploy managed MySQL database for WordPress data storage.

**Tasks Completed:**
1. Created RDS subnet group across private subnets
2. Deployed MySQL RDS instance with Multi-AZ configuration
3. Configured database security group
4. Set up database parameters for WordPress compatibility

**Terraform Components:**
```hcl
resource "aws_db_instance" "wordpress" {
  identifier = "wordpress-db"
  engine     = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  multi_az               = true
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
}
```

**Features Implemented:**
- Multi-AZ deployment for high availability
- Automated backups with 7-day retention
- Storage encryption enabled
- Performance insights enabled

### Step 5: EFS Setup for WordPress Files

**Objective:** Implement shared file storage for WordPress files across multiple instances.

**Tasks Completed:**
1. Created EFS file system with encryption
2. Created EFS mount targets in each AZ
3. Configured EFS security group for NFS access
4. Set up EFS access points for WordPress

**Terraform Components:**
```hcl
resource "aws_efs_file_system" "wordpress" {
  creation_token   = "wordpress-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "provisioned"
  encrypted        = true
  
  provisioned_throughput_in_mibps = 100
}

resource "aws_efs_mount_target" "wordpress" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}
```

**Benefits:**
- Shared storage across multiple EC2 instances
- Automatic scaling and high availability
- Encryption at rest and in transit

### Step 6: Application Load Balancer

**Objective:** Distribute incoming traffic across multiple WordPress instances.

**Tasks Completed:**
1. Created Application Load Balancer in public subnets
2. Configured target group for EC2 instances
3. Set up health checks for WordPress application
4. Configured listener rules for HTTP/HTTPS traffic

**Terraform Components:**
```hcl
resource "aws_lb" "wordpress" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
  
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}
```

**Load Balancer Features:**
- Cross-zone load balancing
- Health checks with automatic failover
- SSL/TLS termination capability
- Integration with Auto Scaling Group

### Step 7: Auto Scaling Group

**Objective:** Automatically adjust EC2 instances based on traffic demand.

**Tasks Completed:**
1. Created launch template with WordPress AMI
2. Configured Auto Scaling Group across multiple AZs
3. Set up scaling policies based on CPU utilization
4. Integrated with Application Load Balancer

**Terraform Components:**
```hcl
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-"
  image_id      = var.wordpress_ami
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.webserver.id]
  
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_endpoint = var.db_endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    efs_id      = var.efs_id
  }))
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress-instance"
    }
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                = "wordpress-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.wordpress.arn]
  health_check_type   = "ELB"
  
  min_size         = 2
  max_size         = 6
  desired_capacity = 2
  
  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}
```

**Auto Scaling Policies:**
- Scale up when CPU > 70% for 2 consecutive periods
- Scale down when CPU < 30% for 2 consecutive periods
- Minimum 2 instances, maximum 6 instances

### Step 8: Route 53 DNS Configuration

**Objective:** Configure DNS for the WordPress domain.

**Tasks Completed:**
1. Created Route 53 hosted zone
2. Configured A record pointing to ALB
3. Set up health checks for failover

## User Data Script

The EC2 instances are configured with a user data script that:
1. Installs and configures Apache web server
2. Installs PHP and required extensions
3. Mounts EFS file system
4. Downloads and configures WordPress
5. Connects to RDS database
6. Sets up WordPress configuration

## Security Measures Implemented

1. **Network Security:**
   - Private subnets for application and database tiers
   - Security groups with least privilege access
   - NAT Gateway for controlled outbound access

2. **Data Protection:**
   - RDS encryption at rest
   - EFS encryption at rest and in transit
   - SSL/TLS for web traffic

3. **Access Control:**
   - IAM roles for EC2 instances
   - Security groups for service isolation
   - SSH access restricted to specific IP ranges

4. **Monitoring:**
   - CloudWatch logs and metrics
   - ALB health checks
   - Auto Scaling notifications

## Deployment Instructions

1. **Clone Repository:**
   ```bash
   git clone <repository-url>
   cd terraform-wordpress
   ```

2. **Configure Variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Plan Deployment:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply
   ```

6. **Access WordPress:**
   - Use the ALB DNS name provided in outputs
   - Complete WordPress installation wizard

## Testing and Validation

### Functionality Testing
1. **WordPress Installation:** Verify WordPress loads correctly
2. **Database Connectivity:** Confirm database connection works
3. **File Upload:** Test file uploads to EFS
4. **Load Balancing:** Verify traffic distribution across instances

### Auto Scaling Demonstration
1. **Load Testing:** Use tools like Apache Bench or Artillery
2. **Monitor Scaling:** Watch CloudWatch metrics and ASG activity
3. **Verify Performance:** Ensure application remains responsive

### Security Validation
1. **Network Access:** Verify security group rules
2. **Database Security:** Confirm RDS is not publicly accessible
3. **SSL/TLS:** Test HTTPS configuration if implemented

## Monitoring and Maintenance

1. **CloudWatch Dashboards:** Monitor key metrics
2. **Log Aggregation:** Centralize application logs
3. **Backup Strategy:** Verify RDS automated backups
4. **Security Updates:** Regular AMI updates for EC2 instances

## Cost Optimization

1. **Reserved Instances:** Consider RIs for predictable workloads
2. **EFS Storage Classes:** Use appropriate storage classes
3. **Auto Scaling:** Right-size instances based on usage patterns
4. **Monitoring:** Set up billing alerts

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues
1. **Database Connection Errors:** Check security groups and RDS status
2. **EFS Mount Issues:** Verify NFS security group rules
3. **Load Balancer Health Checks:** Ensure WordPress is responding on port 80
4. **Auto Scaling Issues:** Check launch template and IAM permissions

### Useful Commands
```bash
# Check Terraform state
terraform show

# Validate configuration
terraform validate

# Format code
terraform fmt

# Check outputs
terraform output
```

## Documentation Deliverables

This project includes comprehensive documentation covering:
- Architecture diagrams and component explanations
- Security measures and best practices implementation
- Step-by-step deployment procedures
- Testing and validation procedures
- Troubleshooting guides and maintenance procedures

## Live Demonstration

The project supports live demonstration of:
1. **WordPress Functionality:** Full website operation
2. **Auto Scaling:** Simulated traffic load testing
3. **High Availability:** Instance failure recovery
4. **Security Features:** Network isolation and access controls

---

**Note:** This implementation follows AWS Well-Architected Framework principles for security, reliability, performance efficiency, cost optimization, and operational excellence.