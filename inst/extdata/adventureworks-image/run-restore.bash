#! /bin/bash

# see https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15
## Restore to SQL Server
docker rm -f `docker ps -aq`
docker build -t mssql:latest -f Dockerfile.mssql .
docker run \
  -e 'ACCEPT_EULA=Y' \
  -e 'MSSQL_SA_PASSWORD=sit-d0wn-COMIC' \
  --name 'adventureworks-mssql' -p 1439:1433 \
  -d mssql
docker exec -it adventureworks-mssql  /var/opt/mssql/backup/restore.bash
docker build -t postgres9:latest -f Dockerfile.postgres9 .
docker run \
  -e 'POSTGRES_PASSWORD=sit-d0wn-COMIC' \
  --name adventureworks-postgresql9 -p 5439:5432 \
  -d postgres9
