# GitHub Actions CI/CD Deployment Course

Welcome to the **GitHub Actions CI/CD Deployment Course**! This guide will walk you through automating deployment pipelines using GitHub Actions, covering versioning, releases, cloud deployments, and environment management.

---

## Course Overview

This course teaches you to:

- **Create automated workflows** for CI/CD
- **Implement versioning and releases**
- **Configure deployments** to AWS, Azure, or Google Cloud
- **Manage environment-specific configurations**

---

## Prerequisites

| Requirement         | Details                                      |
|---------------------|----------------------------------------------|
| GitHub Account      | Sign up at [github.com](https://github.com)  |
| Basic CLI Knowledge | Familiarity with terminal commands           |
| YAML Syntax         | Understanding of GitHub Actions workflow files |
| Cloud Platform      | AWS/Azure/GCP account with permissions       |
| Node.js (Optional)  | For JavaScript projects                      |

---

## Core Concepts

### 1. Deployment Pipeline Stages

- **Integration:** Code changes are merged.
- **Testing:** Automated quality checks run.
- **Staging:** Test in a production-like environment.
- **Production:** Release to end-users.

### 2. Deployment Strategies

- **Blue-Green:** Two identical environments, gradual traffic shift.
- **Canary:** Rollout to a small subset of users first.
- **Rolling:** Incremental replacement of old versions.

---

## Hands-On Modules

### Module 1: Automated Versioning

Automate semantic versioning and tagging on each push.

```yaml
# .github/workflows/versioning.yml
name: Auto Versioning
on: push
jobs:
  version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Generate SemVer
        run: echo "VERSION=1.0.$(date +%s)" >> $GITHUB_ENV
      - name: Create Tag
        run: git tag v${{ env.VERSION }}
```

**Steps Taken:**
1. **Workflow Trigger:** Runs on every push.
2. **Checkout Code:** Uses the official checkout action.
3. **Generate Version:** Creates a unique version using the current timestamp.
4. **Tag Creation:** Tags the commit with the generated version.

---

### Module 2: Cloud Deployment Setup

#### Example: Deploy to AWS S3

```yaml
# .github/workflows/deploy-aws.yml
name: Deploy to AWS
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v3
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}
      - run: aws s3 sync ./dist s3://your-bucket
```

**Steps Taken:**
1. **Workflow Trigger:** Runs on every push.
2. **Checkout Code:** Retrieves the latest code.
3. **Configure AWS Credentials:** Uses secrets stored in GitHub.
4. **Deploy to S3:** Syncs the build output to your S3 bucket.

#### Environment Configuration

- **Store secrets** in GitHub: `Settings > Secrets`
- **Use environment-specific variables:**

```yaml
env:
  PRODUCTION_URL: https://api.example.com
  STAGING_URL: https://staging.api.example.com
```

---

## Troubleshooting Guide

| Issue                        | Solution                                      |
|------------------------------|-----------------------------------------------|
| Workflow fails on push       | Check Actions tab for detailed logs           |
| Cloud access denied          | Verify IAM permissions on cloud platform      |
| Version conflicts            | Clear cache or use unique build numbers       |
| Environment vars not loading | Confirm YAML indentation and scope            |

---

## Course Completion Checklist

- [x] Created automated versioning workflow
- [x] Configured deployment to at least one cloud platform
- [x] Implemented environment-specific variables
- [x] Tested rollback procedure
- [x] Set up monitoring for deployments

---

## Additional Resources

- [Official GitHub Actions Docs](https://docs.github.com/en/actions)
- [AWS Deployment Guide](https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-github-actions.html)
- [Azure Quickstart](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-yaml)
- [Google Cloud Setup](https://cloud.google.com/solutions/ci-cd-github-actions)

---

## Summary of Steps

1. **Set up prerequisites:** Ensure you have accounts and permissions for GitHub and your chosen cloud provider.
2. **Create versioning workflow:** Automate semantic versioning and tagging using GitHub Actions.
3. **Configure cloud deployment:** Set up a deployment workflow for your cloud provider (e.g., AWS S3).
4. **Manage secrets and environment variables:** Store sensitive data in GitHub Secrets and use environment-specific variables in your workflows.
5. **Test and monitor:** Run your workflows, check logs, and set up monitoring for deployments.
6. **Troubleshoot:** Use the troubleshooting guide for common issues.

---
