#!/bin/bash

# Source the environment variables
set -a
source .env
set +a

# Run the playbook
ansible-playbook setup_oci.yml 