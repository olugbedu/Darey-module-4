# Jenkins Pipeline Job Implementation

## Overview

This project demonstrates the implementation of a Jenkins Pipeline Job to automate the build, test, and deployment process using Docker containers. The pipeline integrates with GitHub for source code management and creates a complete CI/CD workflow.

## Prerequisites

- Jenkins server installed and running
- GitHub repository with source code
- Basic understanding of Docker and Jenkins
- Access to server with sudo privileges

## Project Architecture

The Jenkins pipeline follows these stages:
1. **Source Code Checkout** - Connects to GitHub repository
2. **Docker Image Build** - Creates Docker image from Dockerfile
3. **Container Deployment** - Runs the Docker container with NGINX server

## Implementation Steps

### Step 1: Create Jenkins Pipeline Job

1. **Access Jenkins Dashboard**
   - Navigate to Jenkins web interface
   - Click on "New Item" from the left sidebar

2. **Configure Pipeline Job**
   - Enter job name: "My pipeline job"
   - Select "Pipeline" as job type
   - Click "OK" to create

### Step 2: Configure Build Triggers

1. **Set up GitHub Webhook Integration**
   - In job configuration, navigate to "Build Triggers"
   - Select "GitHub hook trigger for GITScm polling"
   - This enables automatic builds when code is pushed to GitHub

2. **Configure GitHub Webhook** (if not already done)
   - In GitHub repository settings, go to "Webhooks"
   - Add webhook URL: `http://your-jenkins-server/github-webhook/`
   - Set content type to `application/json`
   - Select "Just the push event"

### Step 3: Install Docker on Jenkins Server

Before running Docker commands in pipeline, install Docker on the Jenkins server:

1. **Create Docker Installation Script**
   ```bash
   # Create docker.sh file
   nano docker.sh
   ```

2. **Add Installation Commands**
   ```bash
   #!/bin/bash
   sudo apt-get update -y
   sudo apt-get install ca-certificates curl gnupg -y
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg

   # Add the repository to Apt sources
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update -y
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
   sudo systemctl status docker
   ```

3. **Execute Installation**
   ```bash
   chmod u+x docker.sh
   ./docker.sh
   ```

### Step 4: Create Project Files

1. **Create Dockerfile**
   ```dockerfile
   # Use the official NGINX base image
   FROM nginx:latest

   # Set the working directory in the container
   WORKDIR /usr/share/nginx/html/

   # Copy the local HTML file to the NGINX default public directory
   COPY index.html /usr/share/nginx/html/

   # Expose port 80 to allow external access
   EXPOSE 80
   ```

2. **Create index.html**
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Jenkins Pipeline Success</title>
   </head>
   <body>
       <h1>Congratulations, You have successfully run your first pipeline code.</h1>
   </body>
   </html>
   ```

### Step 5: Write Jenkins Pipeline Script

1. **Navigate to Pipeline Configuration**
   - In job configuration, scroll to "Pipeline" section
   - Select "Pipeline script" as Definition

2. **Add Pipeline Script**
   ```groovy
   pipeline {
       agent any
       
       stages {
           stage('Connect To GitHub') {
               steps {
                   checkout scm([
                       branches: [[name: '*/main']], 
                       extensions: [], 
                       userRemoteConfigs: [[url: 'https://github.com/ridwanzi/jenkins-scm.git']]
                   ])
               }
           }
           
           stage('Build Docker Image') {
               steps {
                   script {
                       sh 'docker build -t dockerfile .'
                   }
               }
           }
           
           stage('Run Docker Container') {
               steps {
                   script {
                       sh 'docker run -itd --name nginx -p 8081:80 dockerfile'
                   }
               }
           }
       }
   }
   ```

### Step 6: Pipeline Script Explanation

#### Agent Configuration
```groovy
agent any
```
- Allows pipeline to run on any available Jenkins agent
- Not tied to specific node type

#### Stage 1: GitHub Checkout
```groovy
stage('Connect To GitHub') {
    steps {
        checkout scm([...])
    }
}
```
- Connects to GitHub repository
- Checks out source code from 'main' branch
- Downloads all project files to Jenkins workspace

#### Stage 2: Docker Image Build
```groovy
stage('Build Docker Image') {
    steps {
        script {
            sh 'docker build -t dockerfile .'
        }
    }
}
```
- Builds Docker image using Dockerfile in repository
- Tags image as 'dockerfile'
- Uses current directory (.) as build context

#### Stage 3: Container Deployment
```groovy
stage('Run Docker Container') {
    steps {
        script {
            sh 'docker run -itd --name nginx -p 8081:80 dockerfile'
        }
    }
}
```
- Runs container in detached mode (-itd)
- Names container 'nginx'
- Maps host port 8081 to container port 80
- Uses previously built 'dockerfile' image

### Step 7: Configure Security and Access

1. **Configure Firewall Rules**
   - Open port 8081 in server security groups/firewall
   - Allow inbound traffic on port 8081

2. **Docker Permissions** (if needed)
   ```bash
   # Add jenkins user to docker group
   sudo usermod -aG docker jenkins
   sudo systemctl restart jenkins
   ```

### Step 8: Test and Deploy

1. **Commit and Push Files**
   ```bash
   git add .
   git commit -m "Add Jenkins pipeline configuration"
   git push origin main
   ```

2. **Verify Pipeline Execution**
   - Check Jenkins job console output
   - Monitor each stage execution
   - Verify successful completion

3. **Access Deployed Application**
   - Navigate to: `http://jenkins-server-ip:8081`
   - Verify web page loads successfully

## Troubleshooting

### Common Issues

1. **Docker Permission Denied**
   ```bash
   sudo usermod -aG docker jenkins
   sudo systemctl restart jenkins
   ```

2. **Port Already in Use**
   ```bash
   # Stop existing container
   docker stop nginx
   docker rm nginx
   ```

3. **GitHub Webhook Not Triggering**
   - Verify webhook URL is accessible
   - Check Jenkins GitHub plugin configuration
   - Ensure proper repository permissions

### Pipeline Script Generation

For complex checkout configurations:
1. Use Jenkins Pipeline Syntax Generator
2. Navigate to job → Pipeline Syntax
3. Select "checkout: Check out from version control"
4. Configure repository settings
5. Generate and copy script

## Best Practices

1. **Version Control**: Keep Jenkinsfile in repository root
2. **Error Handling**: Add try-catch blocks for critical steps
3. **Resource Cleanup**: Include cleanup stages for containers/images
4. **Security**: Use Jenkins credentials for sensitive data
5. **Monitoring**: Implement proper logging and notifications

## Success Metrics

✅ Pipeline job created successfully  
✅ GitHub webhook integration configured  
✅ Docker installed and configured  
✅ Pipeline script executes all stages  
✅ Docker container runs successfully  
✅ Web application accessible on port 8081  

## Next Steps

- Implement automated testing stages
- Add deployment to multiple environments
- Configure email notifications
- Integrate with monitoring tools
- Implement rollback mechanisms

## Repository Structure

```
jenkins-scm/
├── Dockerfile
├── index.html
└── README.md
```

## Conclusion

This implementation demonstrates a complete CI/CD pipeline using Jenkins and Docker, providing automated build and deployment capabilities triggered by GitHub commits. The pipeline successfully integrates source code management, containerization, and web service deployment in a streamlined workflow.