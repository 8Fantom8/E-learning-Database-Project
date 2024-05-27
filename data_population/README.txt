Move inside docker: docker `cp data postgres_container:/`
Run on postgres terminal `psql -U root -d postgres -f /data/import_data.sql`

If it does not work or you don't want to use docker.
Move inside your terminal: terminal `cd /E-learning-Database-Project/data_population/data`, then access psql, and copy past the commends of psql_data_population in terminal.
