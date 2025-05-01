# Docker Management Playbooks

This directory contains Ansible playbooks for managing Docker containers and backups.

## Dependencies

### Ansible Collections
```bash
# Install required collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install oracle.oci
```

### OCI Configuration
1. Create OCI config file at `~/.oci/config` with your credentials:
```ini
[DEFAULT]
user=ocid1.user.oc1..your_user_ocid
fingerprint=your_api_key_fingerprint
tenancy=ocid1.tenancy.oc1..your_tenancy_ocid
region=eu-amsterdam-1
key_file=~/.oci/oci_api_key.pem
```

2. Generate API key pair:
```bash
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
chmod 600 ~/.oci/oci_api_key.pem
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

## Usage

### Backup Projects
```bash
# Run with Python environment setup (default)
ansible-playbook backup.yml

# Skip Python environment setup
ansible-playbook backup.yml -e setup_python_env=false
```

This playbook will:
1. Create a Python virtual environment and install OCI SDK (unless skipped)
2. For each project in the inventory:
   - Stop the Docker containers
   - Create a backup of the data directory
   - Start the containers again
   - Upload the backup to OCI bucket
   - Remove the local backup file

## Inventory Structure

The inventory is organized in a directory structure:

```
inventory/
├── hosts                    # Host definitions
├── group_vars/
│   └── all/
│       └── main.yml        # Common variables for all hosts
└── host_vars/
    └── oci-ubuntu-01.yml   # Host-specific variables and projects
```

### Variables

#### Common Variables (group_vars/all/main.yml)
- `backup_dir`: Path where backups are stored
- `venv_path`: Path for Python virtual environment
- `oci_config_file`: Path to OCI config file
- `oci_bucket_name`: Name of the OCI bucket
- `oci_namespace`: Your OCI namespace

#### Host Variables (host_vars/oci-ubuntu-01.yml)
Each host can have multiple projects with:
- `name`: Project name (used in backup filename)
- `config_dir`: Path to the Docker Compose project
- `data_dir`: Path to the data directory to backup

### Playbook Variables
- `setup_python_env`: Set to `false` to skip Python environment setup (default: `true`) 