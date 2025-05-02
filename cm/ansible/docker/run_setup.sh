#!/bin/bash

# Source the environment variables
set -a
source .env
set +a

# Run the playbook
ansible-playbook -i inventory/hosts.yaml setup_oci.yml 