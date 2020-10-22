# A GCP Server Running EasyEngine

This is a sample recipe for creating a GCP server with Terraform that will install EasyEngine.

I did this talk at WP Las Vegas UG (video coming soon) and have [slides](https://docs.google.com/presentation/d/1QuO3urSd6YBVqQB8VtXwQD2gCZ4qbC-BDJWNxbVsVik/edit?usp=sharing)

Goodies to extend this include DNS management with Namecheap and a proper GCP Database Instance.

Feel free to uncomment them in the `domains.tf` and `databases.tf` to try it out.

**Shameless Plug**

If you need a freelance developer, please reach out to me at [Remote Dev Force](https://www.RemoteDevForce.com).

## Install

1. Install terraform with `brew install terraform` (if on Mac)

1. Create a GCP account and install the `gcloud` cli. (google it, it installs through `pip` I think)

1. Run `gcloud auth login` to get a credentials file. Update the `main.tf` file with the path to this json file in the google compute struct.

1. Change all the "acme" words to a short code for your business name or infrastructure codename.

1. Change the gcp project to one you've created in your GCP account in the `variables.tf` file.

1. Add your home/office ip in the `variables.tf` - this will poke a hole for ssh to just these IPs

1. Run the `./tf-apply.sh` script to apply the cloud infrastructure.

1. A file called `terraform.tfstate` will be created, this file is like a snap shot of your provisioned infra. Options are to use the same machine to provision so it has this state file, commit the file but make sure its a private repo (it has sensitive info), or create a backend config to store the state file; checkout terraform.io for more info on that.

1. Now you can upload files to your server by running the script `./scripts/upload-files.sh` - This will upload everything in the `files` directory to the user you have gcloud logged into.

1. SSH into your instance with the server name + zone like so: `gcloud compute ssh tf-acme-wp-001 --zone us-central1-a` or you can with your ssh key like `ssh admin@serverip`

1. Once sshed in, you can use EE commands or just use the script `new-ee-site.sh` - ex. `./new-ee-site.sh example.com www exam` (Read the script to see what it does with ee)

## Migrating Sites

Right now I'm just scp the files across to the new destination server from the original server.

After that, using the following commands to export and import the data.

*Dump the data*

`mysqldump -p -h hostname -u username database_name > dbname.sql`

*Import the data*

`mysql -u username -p database_name < dbname.sql`

## Adding a new server

Add the servername to output.tf and the database.tf to give it access to the database.

Run the uploads script to get files on the server and then run the init-server.sh script to install docker and ee.

## Moving sites

Back up the files in `/var/lib/docker/volumes/wwwthesite_htdocs/_data`

`tar -czvf name-of-archive.tar.gz /path/to/directory-or-file`

scp the backup to the server you need it at.

unpack the tar with `tar -xzvf archive.tar.gz`

Navigate to the files directory and run the following with a new "alias" , in this case "driggs"

`./new-ee-site.sh mywebsite.com www mysite`

The key is not run it with an existing db name/user so we don't overwrite the current state of the site

copy the backup to the docker volumes htdocs directory, move the old htdocs directory

copy the old htdocs directory in its place and the wp-config.php

restart the site with `ee site restart www.thesite.com` and remove the old htdocs directory

Login to the wp-admin and purge the cache, sometimes the site is jacked until you do that

Clean up the new database/user created with the files/utilities/db/drop_database script

You may want to make sure you have the latest wordpress also, do `ee shell www.site.com` and `wp core upgrade`

## TODO

* Add fail2ban https://www.linode.com/docs/security/using-fail2ban-for-security/
* Add sendmail

## Cmds

#### Replace domain/move sites

`wp search-replace 'http://example.dev' 'http://example.com' --skip-columns=guid`

Check for old directories too in the database also.
