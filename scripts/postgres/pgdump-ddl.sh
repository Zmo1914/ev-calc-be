#!/bin/bash

# Configuration
PGDUMP="/usr/bin/pg_dump"

HOST="localhost"
PORT="5432"
DB="neaeas"
SCHEMAS="eas,aud"
USER="bulsiadmin"
PASS="bulsivirtual"

host="localhost"
echo -n "Enter database host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read
#port="5432"
#echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read
db="neaeas"
echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read
#user="bulsiadmin"
#echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read
#pass="enter password"
#echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read
#schemas="eas"
#echo -n "Enter database schemas (default: $schemas): " && read schemas_read && [ -n "$schemas_read" ] && schemas=$schemas_read

OUTPUT_FILE="nea-core/src/main/resources/db/changelog/db-${db}-snapshot.sql"

echo "Generating snapshot DDL..."
echo "Output: ${OUTPUT_FILE}"

while true; do
  read -p "Do you want to proceed? (yes/no) " yn

  case $yn in
    yes )
        $PGDUMP \
          -h "${host}" \
          -p "${PORT}" \
          -U "${USER}" \
          --schema-only \
          --no-owner \
          --no-privileges \
          "${db}" \
          | sed -E '/^\\(un)?restrict/d; s/^CREATE SCHEMA ([^;]+);/CREATE SCHEMA IF NOT EXISTS \1;/' \
          > "${OUTPUT_FILE}"

        if [ $? -eq 0 ]; then
            echo "✅ DDL snapshot generated successfully!"
            echo "File: ${OUTPUT_FILE}"
        else
            echo "❌ Failed to generate DDL snapshot"
            exit 1
        fi
      break;;
    no ) echo exiting...;
      exit;;
    * ) echo invalid response;;
  esac
done

echo done.
#pg_dump -h localhost -p 5432 -U bulsiadmin \
#  --schema-only \
#  --no-owner \
#  --no-privileges \
#  nea > db_schema.sql