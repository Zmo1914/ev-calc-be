#!/bin/bash

# Configuration
#LIQUIBASE=$(command -v liquibase)
LIQUIBASE="/opt/liquibase/liquibase"

# Source
# the database/resource comparing against (Source of Truth)
REF_HOST="localhost"
REF_PORT="5432"
REF_DB="neaeas"
SCHEMAS="eas,aud"
REF_USER="bulsiadmin"
REF_PASS="bulsivirtual"

# Target
# "Current State" (the database actually changing)
HOST="nea-db-dev.bul-si.bg"
PORT="5432"
DB="neaeas"
USER="bulsiadmin"
PASS="bulsivirtual"

OUTPUT_FILE="$(date +%Y%m%d-%H%M%S)-db-changelog-diff.yaml"

echo "Generating diff Liquibase changelog..."
#echo "Database: ${DB_NAME}"
#echo "Output: ${OUTPUT_FILE}"

ref_host="nea-migration-db.az.government.bg"
echo -n "Enter ref host (default: $ref_host): " && read ref_host_read && [ -n "$ref_host_read" ] && ref_host=$ref_host_read

host="localhost"
echo -n "Enter host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read

#port="5432"
#echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read
#db="neaeas"
#echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read
#user="bulsiadmin"
#echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read
#pass="enter password"
#echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read
#schemas="eas,aud"
#echo -n "Enter database schemas (default: $schemas): " && read schemas_read && [ -n "$schemas_read" ] && schemas=$schemas_read

#ref_host="nea-db-dev.bul-si.bg"
#echo -n "Enter REF database host (default: $ref_host): " && read ref_host_read && [ -n "$ref_host_read" ] && ref_host=$ref_host_read
#ref_port="5432"
#echo -n "Enter REF database port (default: $ref_port): " && read ref_port_read && [ -n "$ref_port_read" ] && ref_port=$ref_port_read
#ref_db="neaeas"
#echo -n "Enter REF database name (default: $ref_db): " && read ref_db_read && [ -n "$ref_db_read" ] && ref_db=$ref_db_read
#ref_user="bulsiadmin"
#echo -n "Enter REF database user (default: $ref_user): " && read ref_user_read && [ -n "$ref_user_read" ] && ref_user=$ref_user_read
#ref_pass="enter password"
#echo -n "Enter REF database password (default: $ref_pass): " && read ref_pass_read && [ -n "$ref_pass_read" ] && ref_pass=$ref_pass_read

while true; do
  read -p "Do you want to proceed? (yes/no) " yn

  case $yn in
    yes )
      $LIQUIBASE \
        --driver=org.postgresql.Driver \
        --url="jdbc:postgresql://${host}:${PORT}/${DB}" \
        --username="${USER}" \
        --password="${PASS}" \
        --schemas="${SCHEMAS}" \
        --referenceUrl="jdbc:postgresql://${ref_host}:${REF_PORT}/${REF_DB}" \
        --referenceUsername="${REF_USER}" \
        --referencePassword="${REF_PASS}" \
        --excludeObjects="databasechangelog,databasechangeloglock" \
        --changeLogFile="${OUTPUT_FILE}" \
        diffChangeLog

      if [ $? -eq 0 ]; then
          echo "✅ Changelog generated successfully!"
          echo "File: ${OUTPUT_FILE}"
      else
          echo "❌ Failed to generate changelog"
          exit 1
      fi
      break;;
    no ) echo exiting...;
      exit;;
    * ) echo invalid response;;
  esac
done

echo done.
