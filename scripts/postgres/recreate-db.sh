#!/bin/bash

host="localhost"
function show_hosts {
    echo "Choose database host:"
    echo "local - LOCAL (localhost)"
    echo "dev - DEV (nea-eas-db-dev.bul-si.bg)"
#    echo "stage - STAGE (nea-eas-db-stage.az.government.bg)"
    echo "exit) Exit"
}
while true; do
    show_hosts
    read -p "Enter your choice [local, dev, exit] (default: local (localhost)): " choice

    # Set default choice to local if input is empty
    choice=${choice:-local}

    case $choice in
        local)
            echo "You selected option local (database host localhost)"
            host="localhost"
            break
            ;;
        dev)
            echo "You selected Option dev (database host nea-eas-db-dev.bul-si.bg)"
            host="nea-eas-db-dev.bul-si.bg"
            break
            ;;
#        stage)
#            echo "You selected Option stage (database host nea-eas-db-stage.az.government.bg)"
#            host="nea-eas-db-stage.az.government.bg"
#            break
#            ;;
        exit)
            echo "Exiting the script."
            exit exit
            ;;
        *)
            echo "Invalid choice. Please select from local, dev, exit."
            ;;
    esac

    echo # Print a newline for better readability
done
#host="nea-db-dev.bul-si.bg"
#echo -n "Enter database host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read

port="5432"
echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read

db="ev"
echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read

user="dinevadmin"
echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read

pass="enter password"
echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read

while true; do

read -p "Do you want to proceed? (yes/no) " yn

case $yn in
  yes )
    export PGPASSWORD=$pass
    psql -h $host -p $port -U $user -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$db';"
    psql -h $host -p $port -U $user -d postgres -c "DROP DATABASE \"$db\"";
    psql -h $host -p $port -U $user -d postgres -c "CREATE DATABASE \"$db\"";
    psql -h $host -p $port -U $useaser -d postgres -c "ALTER DATABASE \"$db\" OWNER TO $user";
    psql -h $host -p $port -U $user -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$db\" to $user";
    psql -h $host -p $port -U $user -d $db -c "CREATE SCHEMA IF NOT EXISTS calc;"
    psql -h $host -p $port -U $user -d $db -c "ALTER SCHEMA calc OWNER TO $user;"
    psql -h $host -p $port -U $user -d $db -c "GRANT ALL PRIVILEGES ON SCHEMA calc TO $user;"
    psql -h $host -p $port -U $user -d $db -c "CREATE SCHEMA IF NOT EXISTS aud;"
    psql -h $host -p $port -U $user -d $db -c "ALTER SCHEMA aud OWNER TO $user;"
    psql -h $host -p $port -U $user -d $db -c "GRANT ALL PRIVILEGES ON SCHEMA aud TO $user;"
    unset PGPASSWORD
    break;;
  no ) echo exiting...;
    exit;;
  * ) echo invalid response;;
esac

done

echo done.
