#!/bin/bash

# Configuration
#LIQUIBASE=$(command -v liquibase)
LIQUIBASE="/opt/liquibase/liquibase"

HOST="localhost"
PORT="5432"
DB="eas"
SCHEMAS="eas,aud"
USER="bulsiadmin"
PASS="bulsivirtual"

host="localhost"
#echo -n "Enter database host (default: $host): " && read host_read && [ -n "$host_read" ] && host=$host_read
#port="5432"
#echo -n "Enter database port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read
#db="neaeas"
#echo -n "Enter database name (default: $db): " && read db_read && [ -n "$db_read" ] && db=$db_read
#user="bulsiadmin"
#echo -n "Enter database user (default: $user): " && read user_read && [ -n "$user_read" ] && user=$user_read
#pass="enter password"
#echo -n "Enter database password (default: $pass): " && read pass_read && [ -n "$pass_read" ] && pass=$pass_read
schemas="eas"
echo -n "Enter database schemas (default: $schemas): " && read schemas_read && [ -n "$schemas_read" ] && schemas=$schemas_read

OUTPUT_FILE="nea-core/src/main/resources/db/changelog/db-changelog-${schemas}-initial.yaml"

echo "Generating initial Liquibase changelog..."
echo "Output: ${OUTPUT_FILE}"

while true; do
  read -p "Do you want to proceed? (yes/no) " yn

  case $yn in
    yes )
        $LIQUIBASE \
          --driver=org.postgresql.Driver \
          --url="jdbc:postgresql://${HOST}:${PORT}/${DB}" \
          --username="${USER}" \
          --password="${PASS}" \
          --schemas="${schemas}" \
          --changeLogFile="${OUTPUT_FILE}" \
          --outputDefaultCatalog=false \
          --outputDefaultSchema=false \
          --includeSchema=true \
          --includeCatalog=false \
          --overwrite-output-file=true \
          generateChangeLog

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

#/home/igi/Programs/liquibase-5.0.1/liquibase \
#  --url="jdbc:postgresql://localhost:5432/neaeas" \
#  --username=bulsiadmin \
#  --password=bulsivirtual \
#  --schemas="eas,aud" \
#  --defaultSchemaName=public \
#  --includeSchema=true \
#  --includeCatalog=false \
#  --changeLogFile=nea-core/src/main/resources/db/changelog/db.changelog-initial.yaml \
#  generateChangeLog
