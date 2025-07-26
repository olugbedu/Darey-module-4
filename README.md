# Ansible Linux Server Backup and Restore

A comprehensive guide for automating file backup and restoration processes on Linux servers using Ansible. This project demonstrates how to create scalable and repeatable backup solutions through Ansible playbooks.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Configuration](#configuration)
- [Usage](#usage)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview

This project provides a complete solution for automating backup and restore operations on Linux servers using Ansible. It includes:

- Automated backup of files to designated directories
- Restore functionality to recover files from backups
- SSH key-based authentication setup
- Inventory management for multiple servers
- Testing procedures to verify backup/restore operations

**Estimated Completion Time:** 2-3 hours

## Prerequisites

Before starting, ensure you have:

### System Requirements
- **Control Machine:** Linux system with Ansible installed
- **Target Server(s):** One or more Linux servers to backup
- **Network Access:** SSH connectivity between control machine and target servers

### Required Tools
- Ansible automation platform
- SSH client and server
- Text editor (nano, vim, or preferred editor)
- Basic Linux command line knowledge

### Access Requirements
- SSH access to target servers
- Sudo privileges on target servers (if needed)
- Public key authentication capability

## Installation & Setup

### Step 1: Install Ansible on Control Machine

For Ubuntu/Debian systems:
```bash
sudo apt update
sudo apt install ansible -y
```

For RHEL/CentOS systems:
```bash
sudo yum install epel-release -y
sudo yum install ansible -y
```

### Step 2: Verify Ansible Installation

```bash
ansible --version
```

Expected output should show Ansible version information.

### Step 3: Set Up SSH Key Authentication

Generate SSH key pair:
```bash
ssh-keygen -t rsa
```

Copy public key to target server:
```bash
ssh-copy-id user@target-server-ip
```

Test SSH connection:
```bash
ssh user@target-server-ip
```

## Configuration

### Step 1: Create Ansible Inventory File

Create `inventory.ini`:
```bash
nano inventory.ini
```

Add target server details:
```ini
[linux_servers]
target ansible_host=<target-server-ip> ansible_user=<user>
```

Replace `<target-server-ip>` and `<user>` with actual values.

### Step 2: Test Inventory Connection

```bash
ansible -i inventory.ini linux_servers -m ping
```

Expected output: `SUCCESS` status for all servers.

## Usage

### Creating Backup Playbook

Create `backup.yml`:
```bash
nano backup.yml
```

Add the following content:
```yaml
- name: Backup files on the server
  hosts: linux_servers
  tasks:
    - name: Create backup directory
      file:
        path: /backup
        state: directory
        mode: '0755'

    - name: Copy files to backup directory
      copy:
        src: /path/to/files
        dest: /backup/
        remote_src: yes
```

**Important:** Replace `/path/to/files` with the actual path of files you want to backup.

### Creating Restore Playbook

Create `restore.yml`:
```bash
nano restore.yml
```

Add the following content:
```yaml
- name: Restore files from backup
  hosts: linux_servers
  tasks:
    - name: Copy files back to original location
      copy:
        src: /backup/
        dest: /path/to/files
        remote_src: yes
```

**Important:** Replace `/path/to/files` with the original file location.

### Running the Playbooks

Execute backup operation:
```bash
ansible-playbook -i inventory.ini backup.yml
```

Execute restore operation:
```bash
ansible-playbook -i inventory.ini restore.yml
```

## Testing

### Step 1: Run Backup Process

Execute the backup playbook:
```bash
ansible-playbook -i inventory.ini backup.yml
```

### Step 2: Verify Backup Creation

Check backup directory on target server:
```bash
ls /backup
```

Or remotely via Ansible:
```bash
ansible -i inventory.ini linux_servers -m shell -a "ls -la /backup"
```

### Step 3: Test Restore Process

Run the restore playbook:
```bash
ansible-playbook -i inventory.ini restore.yml
```

### Step 4: Verify Restore Success

Check restored files in original location:
```bash
ls /path/to/files
```

Or remotely via Ansible:
```bash
ansible -i inventory.ini linux_servers -m shell -a "ls -la /path/to/files"
```

## Project Structure

```
ansible-backup-restore/
├── README.md
├── inventory.ini
├── backup.yml
├── restore.yml
└── ansible.cfg (optional)
```

### File Descriptions

- **inventory.ini**: Defines target servers and connection parameters
- **backup.yml**: Ansible playbook for backup operations
- **restore.yml**: Ansible playbook for restore operations
- **ansible.cfg**: Optional Ansible configuration file

## Troubleshooting

### Common Issues and Solutions

#### SSH Connection Failed
```bash
# Test SSH connectivity
ssh -v user@target-server-ip

# Regenerate and copy SSH keys
ssh-keygen -t rsa -f ~/.ssh/id_rsa
ssh-copy-id user@target-server-ip
```

#### Permission Denied Errors
```bash
# Add become: yes to playbook tasks
- name: Create backup directory
  file:
    path: /backup
    state: directory
    mode: '0755'
  become: yes
```

#### Inventory Not Found
```bash
# Use absolute path for inventory
ansible-playbook -i /full/path/to/inventory.ini backup.yml
```

#### File Path Does Not Exist
- Verify source paths exist on target servers
- Use `ansible -m shell -a "ls -la /path"` to check paths
- Ensure proper permissions on source directories

### Debug Mode

Run playbooks in verbose mode for detailed output:
```bash
ansible-playbook -i inventory.ini backup.yml -vvv
```

## Advanced Features

### Multiple Server Support

Add multiple servers to inventory:
```ini
[linux_servers]
server1 ansible_host=192.168.1.10 ansible_user=admin
server2 ansible_host=192.168.1.11 ansible_user=admin
server3 ansible_host=192.168.1.12 ansible_user=admin
```

### Scheduled Backups

Create cron job for automated backups:
```bash
# Add to crontab
0 2 * * * /usr/bin/ansible-playbook -i /path/to/inventory.ini /path/to/backup.yml
```

### Compression Support

Add compression to backup tasks:
```yaml
- name: Create compressed backup
  archive:
    path: /path/to/files
    dest: /backup/backup_{{ ansible_date_time.date }}.tar.gz
    format: gz
```

## Security Considerations

- Use dedicated backup user accounts with minimal privileges
- Implement proper file permissions (0755 for directories, 0644 for files)
- Consider encrypting sensitive backup data
- Regularly rotate SSH keys
- Monitor backup operations through logging

---

**Project Completion Checklist:**
- [ ] Ansible installed and verified
- [ ] SSH key authentication configured
- [ ] Inventory file created and tested
- [ ] Backup playbook created and tested
- [ ] Restore playbook created and tested
- [ ] Backup/restore functionality verified
- [ ] Documentation completed