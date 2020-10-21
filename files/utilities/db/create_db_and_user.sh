#!/usr/bin/env bash
#usage ./create_db_and_user.sh <short name>
# Short name is for mysql username and dbname.

#@todo setup a .my.cnf before using this or add the hostname in the commands

echo "===Creating Database User and Database==="

shortName="$1"
if [[ -z "${shortName}" ]]; then
    echo "You gotta give me something! Ex: myfastwebsite"
    exit
fi

# Create the db for wp
NEW_DB_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
NEW_DB_WP="db_${shortName}"
NEW_DB_USER="${shortName}_user"

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

echo "===Created Database User and Database Successfully==="