#!/bin/bash

ee="/opt/easyengine/sites"
backup="/root/backup"
sites=$(ls $ee)
year=`date +%Y`
month=`date +%m`
day=`date +%d`
date=`date +%Y-%m-%d`

mkdir -p $backup/$year/$month/$day

for i in $sites
do
  ee shell $i --command="wp db export $i.sql"
  cd $ee/$i/app && tar cfJ - htdocs | (pv -ptrb > $i.tar.xz)
  rm $ee/$i/app/htdocs/$i.sql
  mv $ee/$i/app/$i.tar.xz $backup/$year/$month/$day/$i-$date.tar.xz
done

chown -R admin:admin $backup