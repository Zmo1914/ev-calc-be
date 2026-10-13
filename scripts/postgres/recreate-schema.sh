#!/bin/bash

host="localhost"
function show_hosts {
    echo "Choose database host:"
    echo "local - LOCAL (localhost)"
    echo "dev - DEV (nea-db-dev.bul-si.bg)"
    echo "stage - STAGE (nea-db-stage.az.government.bg)"
    echo "migration - MIGRATION (nea-migration-db.az.government.bg)"
    echo "training-dev - TRAINING-DEV (nea-training-db-dev.bul-si.bg)"
    echo "training-stage - TRAINING-STAGE (nea-training-db-stage.az.government.bg)"
    echo "training-migration - TRAINING-MIGRATION (nea-training-migration-db-stage.az.government.bg)"
    echo "exit - Exit"
}
while true; do
    show_hosts
    read -p "Enter your choice [local, dev, stage, training-dev, training-stage, migration, training-migration, exit] (default: local (localhost)): " choice

    # Set default choice to local if input is empty
    choice=${choice:-local}

    case $choice in
        local)
            echo "You selected option local (database host localhost)"
            host="localhost"
            break
            ;;
        dev)
            echo "You selected Option dev (database host nea-db-dev.bul-si.bg)"
            host="nea-db-dev.bul-si.bg"
            break
            ;;
        stage)
            echo "You selected Option stage (database host nea-db-stage.az.government.bg)"
            host="nea-db-stage.az.government.bg"
            break
            ;;
        migration)
            echo "You selected Option migration (database host nea-migration-db.az.government.bg)"
            host="nea-migration-db.az.government.bg"
            break
            ;;
        training-dev)
            echo "You selected Option training-dev (database host nea-training-db-dev.bul-si.bg)"
            host="nea-training-db-dev.bul-si.bg"
            break
            ;;
        training-stage)
            echo "You selected Option training-stage (database host nea-training-db-stage.az.government.bg)"
            host="nea-training-db-stage.az.government.bg"
            break
            ;;
        training-migration)
            echo "You selected Option training-migration (database host nea-training-migration-db-stage.az.government.bg)"
            host="nea-training-migration-db-stage.az.government.bg"
            break
            ;;
        exit)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select from local, dev, stage, training-dev, training-stage, migration, exit."
            ;;
    esac

    echo # Print a newline for better readability
done
#host="nea-db-dev.bul-si.bg"
#echo -n "Enter database host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read

port="5432"
echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read

db="neaeas"
if [ "$choice" = "training-dev" ] || [ "$choice" = "training-stage" ] || [ "$choice" = "training-migration" ]; then
  db="nea-training"
fi
echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read

schema=eas
echo -n "Enter schema name (default: $schema): " && read schema_read && [ -n "$schema_read" ] && schema=$schema_read

user="bulsiadmin"
echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read

pass="enter password"
echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read

while true; do

read -p "Do you want to proceed? (yes/no) " yn

case $yn in
  yes )
    export PGPASSWORD=$pass
    psql -h $host -p $port -U $user -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$db';"
    psql -h $host -p $port -U $user -d $db -c "DROP SCHEMA \"$schema\" CASCADE"
    psql -h $host -p $port -U $user -d $db -c "CREATE SCHEMA \"$schema\""
    psql -h $host -p $port -U $user -d $db -c "ALTER SCHEMA \"$schema\" OWNER TO $user"
    psql -h $host -p $port -U $user -d $db -c "GRANT ALL PRIVILEGES ON SCHEMA \"$schema\" to $user"
    psql -h $host -p $port -U $user -d $db -c "DROP SCHEMA aud CASCADE"
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
