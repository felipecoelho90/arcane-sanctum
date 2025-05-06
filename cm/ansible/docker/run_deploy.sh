#!/bin/bash

# Source the environment variables
set -a
source .env
set +a

# Run the Ansible playbook
ansible-playbook deploy.yml