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

### Stop and Backup
```bash
ansible-playbook stop.yml -i inventory.yaml
```

This playbook will:
1. Stop the Docker containers
2. Create a backup of the data directory
3. Upload the backup to OCI bucket
4. Start the containers again

## Variables

Required variables in `inventory.yaml`:
- `config_dir`: Path to the Docker Compose project
- `data_dir`: Path to the data directory to backup
- `backup_dir`: Path where backups are stored
- `oci_config_file`: Path to OCI config file
- `oci_bucket_name`: Name of the OCI bucket
- `oci_namespace`: Your OCI namespace 