#! /bin/bash

export PGHOST=localhost
export PGPORT=5439
export PGUSER=postgres
export PGPASSWORD=sit-d0wn-COMIC
export PGDATABASE=adventureworks
pgloader --verbose migrate.load 2>&1 | tee migrate.log
