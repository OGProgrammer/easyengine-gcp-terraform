#!/usr/bin/env bash
newSite="$1"
if [ -z "${newSite}" ]; then
    echo "A clean string for the site. Ex: mysite_com"
    exit
fi
mysql -e "DROP USER ${newSite}_user;"
mysql -e "DROP DATABASE wp_${newSite};"
