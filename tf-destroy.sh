#!/usr/bin/env bash
echo "REPOSITORY: easyengine-gcp-terraform"
echo "SCRIPT: tf-destroy.sh"
echo "EXECUTING: terraform destroy"

#Download plugins
terraform get
terraform init

# Uncomment for verbose terraform output
#export TF_LOG=trace

echo "terraform destroy"
if terraform destroy ; then
    echo "Terraform destroy succeeded."
else
    echo 'Error: terraform destroy failed.' >&2
    exit 1
fi

echo "Destroy Completed!";