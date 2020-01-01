echo "creating the 'dvdrental' database"
createdb dvdrental
echo "restoring the database"
pg_restore -U postgres -d dvdrental /dvdrental.tar
echo "running postgresql-autodoc"
cd /var/lib/postgresql
postgresql_autodoc -d dvdrental -t html
