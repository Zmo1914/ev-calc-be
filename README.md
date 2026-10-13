# EV Restful API
Easily extendable RESTful API footing.

The goal of this project is to have a solid and structured foundation to build upon on.

## Features
The following feature set is a minimal selection of typical Web API requirements:

- First [first](https://github.com/user/first)
- Second [second](https://github.com/user/second)

## Start Application
- Clone this repository 
```bash
git clone https://github.com/Zmo1914/ev-calc-be.git
```
- Create a postgres database and add all required variables for your database in the config accordingly if not using same as default
```bash
sudo su postgres

psql -U postgres -c "CREATE ROLE dinevadmin WITH LOGIN PASSWORD 'dinevvirtual';"
# psql -U postgres -c "ALTER ROLE bulsiadmin WITH SUPERUSER;"
psql -U postgres -c "GRANT SET ON PARAMETER session_replication_role TO dinevadmin;"
psql -U postgres -c "ALTER USER dinevadmin CREATEDB;"
psql -U postgres -c "CREATE DATABASE \"ev\";"
psql -U postgres -c "ALTER DATABASE \"ev\" OWNER TO dinevadmin;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"ev\" to dinevadmin;"
psql -U postgres -d neaeas -c "CREATE SCHEMA IF NOT EXISTS eas;"
psql -U postgres -d neaeas -c "ALTER SCHEMA eas OWNER TO dinevadmin;"
psql -U postgres -d neaeas -c "GRANT ALL PRIVILEGES ON SCHEMA eas TO dinevadmin;"
```
- Build the application: ```./mvnw clean package``` or ```./mvnw -DskipTests=true clean package``` (avoid tests)
- Run the application with postgres profile active: ``` java -jar -Dspring.profiles.active=postgres,logging-console nea-resource/target/nea-eas-be.jar```
- Run the application with H2 profile active: ``` java -jar -Dspring.profiles.active=h2,logging-console nea-resource/target/nea-eas-be.jar```
