#!/usr/bin/env bash
echo "REPOSITORY: easyengine-gcp-terraform"
echo "SCRIPT: tf-apply.sh"
echo "EXECUTING: terraform apply"

#Download plugins
terraform get
terraform init

# Uncomment for verbose terraform output
#export TF_LOG=trace

echo "terraform apply"
if terraform apply ; then
    echo "Terraform apply succeeded."
else
    echo 'Error: terraform apply failed.' >&2
    exit 1
fi

echo "Apply Completed!";