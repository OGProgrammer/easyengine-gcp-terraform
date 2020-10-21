#!/usr/bin/env bash
echo "REPOSITORY: easyengine-gcp-terraform"
echo "SCRIPT: tf-plan.sh"
echo "EXECUTING: terraform plan"

#Download plugins
terraform get
terraform init

# Uncomment for verbose terraform output
#export TF_LOG=trace

echo "terraform plan"
if terraform plan ; then
    echo "Terraform plan succeeded."
else
    echo 'Error: terraform plan failed.' >&2
    exit 1
fi

echo "Plan Completed!";