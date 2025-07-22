# Continuous Integration with GitHub Actions

## Overview

This project demonstrates the implementation of Continuous Integration (CI) using GitHub Actions. The tasks carried out in this project align with the requirements of Module 3: Implementing Continuous Integration.

## Requirements Addressed

### 1. Configure Build Matrices for Testing Across Multiple Environments
We created a GitHub Actions workflow using the `matrix` strategy to test across multiple Node.js versions (12.x, 14.x, and 16.x). This allows us to ensure compatibility with different versions of Node.js.

```yaml
strategy:
  matrix:
    node-version: [12.x, 14.x, 16.x]
```

### 2. Manage Build Dependencies Efficiently
We used the `actions/cache@v2` action to cache `node_modules` using the hash of the `package-lock.json` file. This speeds up the workflow by skipping repeated dependency installations.

```yaml
- name: Cache Node Modules
  uses: actions/cache@v2
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

### 3. Integrate Code Analysis Tools into Workflow
We added ESLint to the workflow to run static code analysis and maintain code quality.

```yaml
- name: Run Linter
  run: npx eslint .
```

### 4. Configure Linters and Static Code Analyzers
We ensured the repository has a `.eslintrc` configuration file defining linting rules.

Example `.eslintrc`:

```json
{
  "env": { "browser": true, "es6": true },
  "extends": ["eslint:recommended"],
  "rules": { "no-console": "warn" }
}
```

## Prerequisites

- Knowledge of YAML and GitHub Actions
- Node.js and npm installed
- Basic understanding of testing and linting tools (e.g., ESLint)

## Conclusion

By implementing matrix builds, caching dependencies, and integrating code quality checks, this project sets up a robust CI pipeline using GitHub Actions.
