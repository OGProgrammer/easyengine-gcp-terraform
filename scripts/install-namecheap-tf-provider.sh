#!/usr/bin/env bash
echo "Installing Mac version of Namecheap plugin"
mkdir -p ~/.terraform.d/plugins
wget -O ~/.terraform.d/plugins/terraform-provider-namecheap https://github.com/adamdecaf/terraform-provider-namecheap/releases/download/v1.1.1/terraform-provider-namecheap-osx-amd64
