<?php

if (!isset($argv[1]))
    die();

// override stuff for wp-config
define('ABSPATH', __DIR__.'/');

$wpSite = $argv[1];

if (!file_exists(sprintf('./%s.sql', $wpSite)))
    die('SQL files with wp sitename.sql must be in this dir.');

require "/var/www/$wpSite/wp-config.php";

// At this point we have some defined vars to access the DB
// Execute a nasty DB import command with shell exec
echo shell_exec(sprintf('mysql -p%s -h %s -u %s %s < %s.sql', DB_PASSWORD, DB_HOST, DB_USER, DB_NAME, $wpSite));
