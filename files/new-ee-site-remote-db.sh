#!/usr/bin/env bash
#usage ./new-ee-site-remote-db.sh <domain name≥ <subdomain> <short name>
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
NEW_DB_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
NEW_DB_WP="wp_${shortName}"
NEW_DB_USER="${shortName}_user"
NEW_ADMIN_PW=$(echo -n `date`$newSiteUser | sha1sum | cut -c -20)
ADMIN_EMAIL="your@email"
DB_HOST="your_db_host"

# Create Mysql Database + User
RESULT=`mysql --skip-column-names -e "SHOW DATABASES LIKE '$NEW_DB_WP'"`
if [[ "$RESULT" == "$NEW_DB_WP" ]]; then
    echo "Database already exists. Skipping db setup."
else
    echo "Database does not exist. Creating database and user."
    echo "-----"
    echo "Executing: mysql -e \"CREATE DATABASE $NEW_DB_WP; CREATE USER \"$NEW_DB_USER\"@\"%\" IDENTIFIED BY '$NEW_DB_PW'; GRANT ALL PRIVILEGES ON $NEW_DB_WP.* TO \"$NEW_DB_USER\"@\"%\"; FLUSH PRIVILEGES;\""
    echo "-----"
    if mysql -e "CREATE DATABASE $NEW_DB_WP; CREATE USER \"$NEW_DB_USER\"@\"%\" IDENTIFIED BY '$NEW_DB_PW'; GRANT ALL PRIVILEGES ON $NEW_DB_WP.* TO \"$NEW_DB_USER\"@\"%\"; FLUSH PRIVILEGES;" ; then
        echo "New password for user $NEW_DB_USER for db $NEW_DB_WP is $NEW_DB_PW (Save this PW if files already exist for site!)"
        echo "-----"
    else
        echo 'Error: Failed to create mysql user/database.' >&2
        exit 1
    fi
fi

# Install WP
echo "No previous data found, now installing a fresh copy of Wordpress in the DB..."
echo "Executing: sudo ee site create $subdomain.$newSiteDomain --type=wp --cache --title=$newSiteDomain --admin-email=$ADMIN_EMAIL --admin-pass=$NEW_ADMIN_PW --admin-user=$newSiteDomain --dbhost=$DB_HOST --dbuser=$NEW_DB_USER --dbpass=$NEW_DB_PW --dbname=$NEW_DB_WP --with-local-redis --ssl=le --le-mail=$ADMIN_EMAIL --yes"
sudo ee site create $subdomain.$newSiteDomain --type=wp --cache --title=$newSiteDomain \
        --admin-email=$ADMIN_EMAIL --admin-pass=$NEW_ADMIN_PW --admin-user=$newSiteDomain \
        --dbhost=$DB_HOST --dbuser=$NEW_DB_USER --dbpass=$NEW_DB_PW --dbname=$NEW_DB_WP \
        --with-local-redis --ssl=le --le-mail=$ADMIN_EMAIL --yes

if [[ $? -ne 0 ]]; then
    echo 'Error: easyengine failed to create site.' >&2
    exit 1
else
    echo 'Site created successfully.'
    echo "New WordPress user created for https://$newSiteDomain with the username $newSiteDomain and password $NEW_ADMIN_PW"
fi

# Import data if sql file exists
if [[ -f "./$newSiteDomain.sql" ]]; then
    echo "SQL File found for site data! Now importing old data..."
    if mysql -p$NEW_DB_PW -h $DB_HOST -u $NEW_DB_USER $NEW_DB_WP < ./$newSiteDomain.sql ; then
        echo 'Mysql dumped data loaded successfully.'
    else
        echo 'Error: Failed to import previous database.' >&2
        exit 1
    fi
fi

# WordPress
if [[ -d "./$newSiteDomain" ]]; then
    echo "Directory found for site data! Now syncing easyengine directories..."
    if sudo rsync -av ./${newSiteDomain} /var/lib/docker/volumes/${subdomain}${newSiteDomainClean}_htdocs/_data/htdocs ; then
        echo 'Rsyncd backed up site files successfully.'
    else
        echo 'Error: Failed to sync backed up data to new web directory.' >&2
        exit 1
    fi
    sudo rm /opt/easyengine/sites/${subdomain}.${newSiteDomain}/app/htdocs/wp-config.php > /dev/null
fi

echo "Bouncing the site now..."
sudo ee site restart $subdomain.$newSiteDomain

echo "===New EasyEngine Wordpress Site Completed==="