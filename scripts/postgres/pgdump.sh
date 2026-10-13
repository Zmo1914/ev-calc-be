#!/bin/bash

PGDUMP="/usr/bin/pg_dump"

host="127.0.0.1"
#host="nea-db-dev.bul-si.bg"
echo -n "Enter database host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read

port="5432"
echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read

db="neaeas"
echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read

schema="eas"
echo -n "Enter schema name (default: $schema): " && read schema_read && [ -n "$schema_read" ] && db=$schema_read

user="bulsiadmin"
echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read

pass="enter password"
echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read

date=`date +%Y%m%d-%H%M%S`

export PGPASSWORD=$pass

#$PGDUMP -U $user -h $host -p $port -d $db -F c -f $db-$date.dump --exclude-schema=work --exclude-schema=dwh --exclude-schema=lmesf --exclude-schema=public
$PGDUMP -U $user -h $host -p $port -d $db -n $schema -F c -f $db-$date.dump

unset PGPASSWORD

echo done.

exit 0
