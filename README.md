# Jenkins CI/CD

## Introduction to CI/CD

**Continuous Integration and Continuous Delivery (CI/CD)** are best practices that automate the software development lifecycle. CI/CD enhances efficiency, stability, and deployment speed by enabling frequent code integration, automated testing, and reliable deployment pipelines [[1]][[5]].

---

## What is Jenkins?

**Jenkins** is an open-source automation server that automates building, testing, and deploying applications. It supports pipelines to define entire workflows, integrates with version control systems for automatic builds, and offers an extensive plugin ecosystem for cus# Jenkins Freestyle Project Setup Guide

This guide walks you through creating a Jenkins Freestyle project with GitHub integration and automated build triggers.

## Overview

A Jenkins job is a unit of work that automates tasks in the build/deployment process. Freestyle projects are ideal for simple, linear workflows and can:

- Compile code
- Run tests
- Package applications
- Deploy to servers

## Prerequisites

- Jenkins server installed and running
- GitHub account
- Admin access to Jenkins
- Network connectivity between Jenkins and GitHub

## Step 1: Create a Jenkins Freestyle Project

1. **Access Jenkins Dashboard**
   - Navigate to your Jenkins server
   - Log in with appropriate credentials

2. **Create New Item**
   - Click "New Item" in the left menu
   - Enter a descriptive name (e.g., `my-first-job`)
   - Select "Freestyle project"
   - Click "OK"

## Step 2: Set Up GitHub Repository

1. **Create GitHub Repository**
   - Create a new GitHub repository named `jenkins-demo`
   - Initialize with a README.md file
   - Note the repository URL: `https://github.com/olugbedu/jenkins-demo.git`

## Step 3: Configure Source Code Management

1. **Connect to GitHub Repository**
   - In Jenkins job configuration page
   - Navigate to "Source Code Management" section
   - Select "Git"
   - Enter repository URL: `https://github.com/olugbedu/jenkins-demo.git`

2. **Add Credentials (if repository is private)**
   - Click "Add" next to Credentials
   - Configure GitHub username and password/token
   - Select the added credentials from dropdown

3. **Save Configuration**
   - Click "Save" to store the configuration

## Step 4: Test Initial Build

1. **Run Manual Build**
   - Click "Build Now" from the project page
   - Monitor the build progress

2. **Verify Connection**
   - Check console output for successful connection
   - Ensure repository is cloned successfully
   - Verify no authentication errors

## Step 5: Configure Automated Build Triggers

### Option A: GitHub Webhooks (Recommended)

1. **Configure Jenkins Build Triggers**
   - Go to job configuration
   - Under "Build Triggers", select "GitHub hook trigger for GITScm polling"
   - Save configuration

2. **Set Up GitHub Webhook**
   - Navigate to your GitHub repository
   - Go to Settings > Webhooks
   - Click "Add webhook"
   - Set payload URL: `http://<your-jenkins-server>/github-webhook/`
   - Set content type to `application/json`
   - Select "Just the push event" or customize events
   - Click "Add webhook"

### Option B: SCM Polling

1. **Configure Polling Schedule**
   - In job configuration under "Build Triggers"
   - Select "Poll SCM"
   - Enter schedule (e.g., `* * * * *` for every minute)
   - Save configuration

## Step 6: Test Automation

1. **Make a Test Change**
   - Edit any file in your repository (e.g., README.md)
   - Add some content or modify existing content

2. **Push Changes**
   - Commit and push changes to the master/main branch
   ```bash
   git add .
   git commit -m "Test automated build trigger"
   git push origin main
   ```

3. **Verify Automatic Build**
   - Check Jenkins dashboard
   - Confirm a new build started automatically
   - Monitor build progress and console output

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build not triggering | • Verify webhook delivery in GitHub settings<br>• Check Jenkins webhook URL accessibility<br>• Ensure correct payload URL format |
| Repository access denied | • Re-configure credentials in Jenkins<br>• Verify GitHub token permissions<br>• Check repository visibility settings |
| Polling not working | • Verify "Poll SCM" schedule syntax<br>• Check Jenkins system logs<br>• Ensure SCM changes are detected |
| Webhook delivery failed | • Check network connectivity<br>• Verify Jenkins server is accessible from GitHub<br>• Review firewall settings |

## Important Checks

Before proceeding, ensure:

- ✅ GitHub permissions (admin access required for webhooks)
- ✅ Jenkins credentials properly configured
- ✅ Network connectivity between Jenkins and GitHub
- ✅ Webhook payload URL is accessible
- ✅ Repository branch matches Jenkins configuration

## Next Steps

Once your basic Freestyle project is working, consider these enhancements:

1. **Add Build Steps**
   - Configure build commands (e.g., `mvn clean install`, `npm install`)
   - Add test execution steps
   - Include code quality checks

2. **Configure Post-Build Actions**
   - Archive build artifacts
   - Publish test results
   - Deploy to staging/production environments

3. **Set Up Notifications**
   - Configure email notifications for build failures
   - Set up Slack or other team communication integrations
   - Create build status badges for your repository

4. **Advanced Configuration**
   - Set up build parameters
   - Configure multiple branches
   - Implement build pipelines with multiple stages

## Conclusion

You now have a functional Jenkins Freestyle project that automatically triggers builds when code changes are pushed to your GitHub repository. This foundation can be extended with additional build steps, testing, and deployment automation as your project requirements grow.tomization [[2]][[3]][[9]][[10]].

---

## Installation Guide

### Prerequisites

- Completed foundational programs 1-3
- System with JDK installed

### Installation Steps

1. **Update package repositories:**
    ```bash
    sudo apt-get update
    ```

2. **Install JDK:**
    ```bash
    sudo apt-get install default-jdk
    ```

3. **Add Jenkins repository and install:**
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    ```

4. **Verify installation:**
    ```bash
    sudo systemctl status jenkins
    ```

5. **Access Jenkins web console:**
    ```
    http://<public-ip>:8080
    ```

6. **Retrieve initial admin password:**
    ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

---

## Project Goals

By completing this learning path, you will:

- Understand CI/CD principles and their benefits
- Install and configure Jenkins
- Create and manage Jenkins jobs
- Automate software builds and tests
- Implement deployment pipelines
- Integrate with version control systems

---

## Getting Started with Jenkins

### Initial Setup

1. **Install required plugins:**
    - Navigate to **Manage Jenkins > Plugins**
    - Install suggested plugins or select specific ones

2. **Create admin user:**
    - Set up credentials after initial login

3. **Configure security:**
    - Set up appropriate security groups
    - Ensure port 8080 is accessible

---

### Basic Operations

- **Create your first job:**
    - Go to **New Item > Enter name > Select "Freestyle project"**
    - Configure source code management (Git, SVN)
    - Set build triggers
    - Add build steps (shell commands, etc.)

- **Pipeline creation:**
    - Define a `Jenkinsfile` with stages
    - Configure build, test, and deploy steps

---

## Common Tasks Checklist

- [ ] Install Jenkins
- [ ] Configure security settings
- [ ] Install necessary plugins
- [ ] Create admin user account
- [ ] Connect to version control
- [ ] Create first build job
- [ ] Test pipeline execution
- [ ] Configure deployment steps

---

## Troubleshooting

- **Port conflicts:** Change Jenkins port in `/etc/default/jenkins`
- **Connection issues:** Verify security group rules
- **Plugin errors:** Check compatibility and versions
- **Build failures:** Review console output for errors

---

## Next Steps

- Explore advanced pipeline syntax
- Learn about Jenkins agents/distributed builds
- Implement blue-green deployments
- Set up monitoring for Jenkins

---
