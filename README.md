# GitHub Actions CI/CD Project

## Overview

This project demonstrates the implementation of Continuous Integration and Continuous Deployment (CI/CD) practices using GitHub Actions. The project involves creating a simple Node.js web application and setting up automated workflows for building, testing, and deploying the application.

## What is CI/CD?

**Continuous Integration (CI)** is the practice of merging all developers' working copies to a shared mainline several times a day, followed by automated building and testing.

**Continuous Deployment (CD)** is the process of releasing software changes to production automatically and reliably after passing all tests and quality checks.

### Benefits of CI/CD
- Faster release rate
- Improved developer productivity
- Better code quality
- Enhanced customer satisfaction
- Early detection of bugs and issues
- Reduced manual errors

## Prerequisites

Before starting this project, ensure you have:

1. **Git and GitHub Knowledge**
   - Understanding of version control concepts
   - Familiarity with Git operations (clone, commit, push, pull)
   - Active GitHub account

2. **Programming Fundamentals**
   - Basic JavaScript knowledge
   - Understanding of web application concepts
   - Familiarity with Node.js and npm

3. **Development Environment**
   - Node.js and npm installed locally
   - Text editor or IDE (VS Code recommended)
   - Command line/terminal access
   - Stable internet connection

## Project Setup

### Step 1: Initialize GitHub Repository

1. Create a new repository on GitHub:
   ```bash
   # Go to GitHub.com and click "New repository"
   # Name it something like "nodejs-cicd-project"
   # Initialize with README (optional)
   ```

2. Clone the repository locally:
   ```bash
   git clone https://github.com/yourusername/nodejs-cicd-project.git
   cd nodejs-cicd-project
   ```

### Step 2: Create Node.js Application

1. Initialize the Node.js project:
   ```bash
   npm init -y
   ```

2. Install Express.js dependency:
   ```bash
   npm install express
   npm install --save-dev jest supertest
   ```

3. Create the main application file (`index.js`):
   ```javascript
   const express = require('express');
   const app = express();
   const port = process.env.PORT || 3000;

   app.get('/', (req, res) => {
       res.send("Hello World! CI/CD Pipeline is working!");
   });

   app.get('/health', (req, res) => {
       res.status(200).json({ status: 'OK', message: 'Application is healthy' });
   });

   const server = app.listen(port, () => {
       console.log(`App listening at http://localhost:${port}`);
   });

   module.exports = { app, server };
   ```

4. Update `package.json` scripts:
   ```json
   {
     "scripts": {
       "start": "node index.js",
       "test": "jest",
       "build": "echo 'Build completed successfully'"
     }
   }
   ```

5. Create a simple test file (`test/app.test.js`):
   ```javascript
   const request = require('supertest');
   const { app, server } = require('../index');

   describe('GET /', () => {
     it('should return Hello World message', async () => {
       const res = await request(app).get('/');
       expect(res.statusCode).toEqual(200);
       expect(res.text).toContain('Hello World');
     });
   });

   describe('GET /health', () => {
     it('should return health status', async () => {
       const res = await request(app).get('/health');
       expect(res.statusCode).toEqual(200);
       expect(res.body.status).toEqual('OK');
     });
   });

   afterAll(() => {
     server.close();
   });
   ```

### Step 3: Create GitHub Actions Workflow

1. Create the workflow directory structure:
   ```bash
   mkdir -p .github/workflows
   ```

2. Create the main CI workflow (`.github/workflows/ci.yml`):
   ```yaml
   name: Node.js CI/CD Pipeline

   # Trigger the workflow on push and pull requests to main branch
   on:
     push:
       branches: [ main, develop ]
     pull_request:
       branches: [ main ]

   jobs:
     # Job 1: Build and Test
     test:
       runs-on: ubuntu-latest
       
       strategy:
         matrix:
           node-version: [14.x, 16.x, 18.x]
       
       steps:
       # Step 1: Checkout repository code
       - name: Checkout code
         uses: actions/checkout@v3
         
       # Step 2: Setup Node.js environment
       - name: Setup Node.js ${{ matrix.node-version }}
         uses: actions/setup-node@v3
         with:
           node-version: ${{ matrix.node-version }}
           cache: 'npm'
           
       # Step 3: Install dependencies
       - name: Install dependencies
         run: npm ci
         
       # Step 4: Run build script
       - name: Run build
         run: npm run build --if-present
         
       # Step 5: Run tests
       - name: Run tests
         run: npm test
         
       # Step 6: Generate test coverage (optional)
       - name: Generate test coverage
         run: npm run test -- --coverage --watchAll=false
         if: matrix.node-version == '18.x'

     # Job 2: Code Quality Checks
     lint:
       runs-on: ubuntu-latest
       needs: test
       
       steps:
       - name: Checkout code
         uses: actions/checkout@v3
         
       - name: Setup Node.js
         uses: actions/setup-node@v3
         with:
           node-version: '18.x'
           cache: 'npm'
           
       - name: Install dependencies
         run: npm ci
         
       # Add linting step (requires eslint to be installed)
       - name: Run linter
         run: echo "Linting step - install ESLint for actual linting"

     # Job 3: Security Audit
     security:
       runs-on: ubuntu-latest
       needs: test
       
       steps:
       - name: Checkout code
         uses: actions/checkout@v3
         
       - name: Setup Node.js
         uses: actions/setup-node@v3
         with:
           node-version: '18.x'
           cache: 'npm'
           
       - name: Install dependencies
         run: npm ci
         
       - name: Run security audit
         run: npm audit --audit-level=moderate

     # Job 4: Deploy (runs only on main branch)
     deploy:
       runs-on: ubuntu-latest
       needs: [test, lint, security]
       if: github.ref == 'refs/heads/main'
       
       steps:
       - name: Checkout code
         uses: actions/checkout@v3
         
       - name: Setup Node.js
         uses: actions/setup-node@v3
         with:
           node-version: '18.x'
           cache: 'npm'
           
       - name: Install dependencies
         run: npm ci
         
       - name: Build application
         run: npm run build --if-present
         
       - name: Deploy to staging
         run: |
           echo "Deploying to staging environment..."
           echo "Application deployed successfully!"
   ```

### Step 4: Additional Workflow Examples

Create a separate deployment workflow (`.github/workflows/deploy.yml`):

```yaml
name: Deploy to Production

on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18.x'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Build application
      run: npm run build --if-present
      
    - name: Deploy to production
      run: |
        echo "Deploying to production..."
        echo "Production deployment completed!"
```

### Step 5: Commit and Push Changes

1. Add all files to Git:
   ```bash
   git add .
   git commit -m "Initial setup: Node.js app with CI/CD pipeline"
   git push origin main
   ```

2. Monitor the workflow execution on GitHub:
   - Go to your repository on GitHub
   - Click on the "Actions" tab
   - Watch your workflows run automatically

## Understanding GitHub Actions Components

### Workflows
Configurable automated processes defined by YAML files in `.github/workflows/`. They contain one or more jobs that run when triggered by events.

### Events
Activities that trigger workflows such as:
- `push` - Code pushed to repository
- `pull_request` - Pull request opened/updated
- `schedule` - Time-based triggers
- `release` - Release created

### Jobs
Sets of steps that execute on the same runner. Jobs can run:
- Sequentially (using `needs`)
- In parallel (default behavior)

### Steps
Individual tasks within jobs that can:
- Run shell commands
- Use pre-built actions
- Execute scripts

### Actions
Reusable units of code that can be:
- Created by you
- From GitHub Marketplace
- From the community

### Runners
Servers that execute workflows:
- GitHub-hosted (Ubuntu, Windows, macOS)
- Self-hosted (your own infrastructure)

## Testing Your Implementation

### Local Testing
```bash
# Install dependencies
npm install

# Run tests locally
npm test

# Start the application
npm start
```

### Workflow Testing
1. Make changes to your code
2. Create a pull request
3. Observe the CI pipeline running
4. Merge to main branch
5. Watch the deployment workflow execute

## Advanced Features to Explore

### 1. Environment Variables and Secrets
```yaml
env:
  NODE_ENV: production
  
steps:
- name: Use secret
  run: echo "Using secret: ${{ secrets.MY_SECRET }}"
```

### 2. Conditional Execution
```yaml
- name: Deploy only on main branch
  if: github.ref == 'refs/heads/main'
  run: echo "Deploying to production"
```

### 3. Matrix Strategy
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node-version: [14.x, 16.x, 18.x]
```

### 4. Artifacts and Caching
```yaml
- name: Cache node modules
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

## Troubleshooting

### Common Issues
1. **Workflow not triggering**: Check event configuration in YAML
2. **Tests failing**: Verify test scripts and dependencies
3. **Node version conflicts**: Use matrix strategy for multiple versions
4. **Permission errors**: Check repository permissions and secrets

### Debugging Tips
- Use `run: echo "Debug info: ${{ github.event_name }}"` for debugging
- Check workflow logs in GitHub Actions tab
- Validate YAML syntax using online validators

## Best Practices

1. **Keep workflows simple** - Split complex workflows into multiple files
2. **Use semantic versioning** - Tag releases properly
3. **Implement proper testing** - Unit, integration, and e2e tests
4. **Security first** - Use secrets for sensitive data
5. **Monitor performance** - Track build times and optimize
6. **Document changes** - Clear commit messages and PR descriptions

## Next Steps

1. **Add real deployment targets** (Heroku, AWS, Azure, etc.)
2. **Implement comprehensive testing** (unit, integration, e2e)
3. **Add code quality tools** (ESLint, Prettier, SonarQube)
4. **Set up monitoring** (health checks, logging)
5. **Implement feature flags** for safe deployments
6. **Add notification systems** (Slack, email alerts)

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Community Forums](https://github.community/)
