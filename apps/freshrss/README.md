# FreshRSS Deployment

This directory contains Ansible playbooks and roles for deploying and managing FreshRSS.

## Prerequisites

- Ansible 2.9 or later
- Python 3.6 or later
- SSH access to the target server
- OCI CLI configured (for backup functionality)

## Configuration

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file with your server details:
   ```bash
   # Required variables
   FRESHRSS_HOST=your-server-ip-or-hostname
   FRESHRSS_USER=ubuntu
   FRESHRSS_SSH_KEY=~/.ssh/your-key.pem

   # Optional variables
   FRESHRSS_APP_DIR=/opt/freshrss
   FRESHRSS_BACKUP_BUCKET=freshrss-backups
   FRESHRSS_TIMEZONE=Europe/Amsterdam
   ```

3. Source the environment variables:
   ```bash
   source .env
   ```

## Usage

### Deploy FreshRSS
```bash
ansible-playbook -i inventory.yml deploy.yml
```

### Update FreshRSS
```bash
ansible-playbook -i inventory.yml update.yml
```

### Backup FreshRSS
```bash
ansible-playbook -i inventory.yml backup.yml
```

## Inventory Structure

The inventory file (`inventory.yml`) defines the following:

- Host group: `freshrss`
- Default host: `freshrss`
- Connection variables:
  - `ansible_host`: Server IP or hostname
  - `ansible_user`: SSH user
  - `ansible_ssh_private_key_file`: SSH key path
  - `ansible_python_interpreter`: Python interpreter path

## Variables

Variables can be set in multiple places (in order of precedence):
1. Environment variables
2. Inventory file
3. Role defaults

## Security Notes

- Keep your `.env` file secure and never commit it to version control
- Use a dedicated SSH key for deployment
- Consider using Ansible Vault for sensitive variables 