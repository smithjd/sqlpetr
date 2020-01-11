FROM mcr.microsoft.com/mssql/server:2019-latest
LABEL maintainer="M. Edward (Ed) Borasky <znmeb@znmeb.net>"

USER root
WORKDIR /var/opt/mssql/backup/
COPY restore.bash /var/opt/mssql/backup/
RUN wget -q \
  'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak'
USER mssql
