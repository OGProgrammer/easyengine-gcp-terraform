#!/usr/bin/env bash
echo "ALL USERS"
sudo mysql -e "SELECT user FROM mysql.user GROUP BY user;"
