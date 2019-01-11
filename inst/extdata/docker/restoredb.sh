#! /bin/bash

echo "creating the 'dvdrental' database"
createdb dvdrental
echo "restoring the database"
pg_restore -U postgres -d dvdrental /dvdrental.tar
