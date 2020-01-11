#! /bin/bash

# see https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15
## Restore to SQL Server
docker rm -f `docker ps -aq`
docker network create adventureworks
docker build -t mssql:latest -f Dockerfile .
docker run \
  -e 'ACCEPT_EULA=Y' \
  -e 'MSSQL_SA_PASSWORD=sit-d0wn-COMIC' \
  --name mssql -p 1433:1433 \
  --hostname mssql \
  --network adventureworks \
  -d mssql
docker exec -it mssql  /var/opt/mssql/backup/restore.bash
docker build -t postgres9:latest -f Dockerfile.postgres9 .
docker run \
  -e 'POSTGRES_PASSWORD=sit-d0wn-COMIC' \
  --name postgresql9 -p 5439:5432 \
  --hostname postgresql9 \
  --network adventureworks \
  -d postgres9
