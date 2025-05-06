#!/bin/bash

set -a
source .env
set +a

# Run the playbook
ansible-playbook house_keeping.yml