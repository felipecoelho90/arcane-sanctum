# Docker Project Management

This directory contains Ansible playbooks for managing Docker projects on remote servers.

## Directory Structure

```
.
├── inventory/              # Ansible inventory files
│   ├── hosts.yaml         # Host definitions
│   ├── group_vars/        # Group variables
│   └── host_vars/         # Host-specific variables
├── templates/             # Jinja2 templates
│   ├── oci_config.j2     # OCI configuration template
│   └── arcane-sanctum.pem.j2  # OCI private key template
├── .env                   # Environment variables for OCI
├── setup_oci.yml         # Playbook for OCI setup
├── backup.yml            # Playbook for project backups
├── backup_project.yml    # Playbook for individual project backup
└── run_setup.sh          # Helper script for OCI setup
```

## Prerequisites

1. Ansible installed on your local machine
2. SSH access to the target servers
3. OCI (Oracle Cloud Infrastructure) account and credentials

## Environment Setup

1. Create a `.env` file with your OCI credentials:
   ```
   OCI_USER=your_user_ocid
   OCI_FINGERPRINT=your_key_fingerprint
   OCI_TENANCY=your_tenancy_ocid
   OCI_REGION=your_region
   OCI_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
   ```

2. Make the setup script executable:
   ```bash
   chmod +x run_setup.sh
   ```

## Usage

### Setting up OCI Configuration

To set up OCI configuration on the target servers:

```bash
./run_setup.sh
```

This will:
- Create the `.oci` directory
- Set up the OCI configuration file
- Create the private key file
- Install the OCI Python SDK

### Backing up Projects

To back up all configured projects:

```bash
ansible-playbook -i inventory/hosts.yaml backup.yml
```

The backup process:
1. Stops the project's containers
2. Creates a backup of the project's data directory
3. Starts the containers again
4. Uploads the backup to an OCI bucket
5. Removes the local backup file

## Project Configuration

Projects are configured in the inventory files. Each project should have:
- A name
- A configuration directory
- A data directory

Example project configuration in `inventory/hosts.yaml`:
```yaml
projects:
  - name: tandoor
    config_dir: /home/docker/git/tandoor
    data_dir: /mnt/docker-data/tandoor
```

## Security Notes

- The `.env` file contains sensitive information and should not be committed to version control
- The OCI private key file is created with restricted permissions (600)
- The `.oci` directory is created with restricted permissions (700) 