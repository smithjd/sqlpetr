SELECT schema_name FROM information_schema.schemata
WHERE left(schema_name, 3) != 'pg_'
AND schema_name != 'information_schema';