#!/usr/bin/env bash
#usage ./new-ee-site.sh <domain name≥ <subdomain> <short name>
# Short name is for when domain name is too long for mysql username.

echo "===Creating New EasyEngine WordPress Site==="

newSiteDomain="$1"
if [ -z "${newSiteDomain}" ]; then
    echo "Site param missing! Script needs the domain name of the site. Ex: mysite.com"
    exit
fi
newSiteUser="${newSiteDomain//./_}"
newSiteDomainClean="${newSiteDomain//./}"

subdomain="$2"
if [[ -z "${subdomain}" ]]; then
    subdomain="www"
fi

shortName="$3"
if [[ -z "${shortName}" ]]; then
    shortName="${subdomain}_${newSiteDomainClean}"
fi

# Create the db for wp
NEW_ADMIN_PW=$(echo -n `date`$newSiteUser | sha1sum | cut -c -20)
ADMIN_EMAIL="your@email"

# Install WP
echo "No previous data found, now installing a fresh copy of Wordpress in the DB..."
echo "Executing: sudo ee site create $subdomain.$newSiteDomain --type=wp --cache --title=$newSiteDomain --admin-email=$ADMIN_EMAIL --admin-pass=$NEW_ADMIN_PW --admin-user=$newSiteDomain --with-local-redis --ssl=le --le-mail=$ADMIN_EMAIL --yes"
sudo ee site create $subdomain.$newSiteDomain --type=wp --cache --title=$newSiteDomain \
        --admin-email=$ADMIN_EMAIL --admin-pass=$NEW_ADMIN_PW --admin-user=$newSiteDomain \
        --with-local-redis --ssl=le --le-mail=$ADMIN_EMAIL --yes

if [[ $? -ne 0 ]]; then
    echo 'Error: easyengine failed to create site.' >&2
    exit 1
else
    echo 'Site created successfully.'
    echo "New WordPress user created for https://$newSiteDomain with the username $newSiteDomain and password $NEW_ADMIN_PW"
fi

echo "Bouncing the site now..."
sudo ee site restart $subdomain.$newSiteDomain

echo "===New EasyEngine Wordpress Site Completed==="