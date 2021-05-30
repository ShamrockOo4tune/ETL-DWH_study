#!/bin/bash

echo Starting docker containers deployment:;
docker-compose up -d;
sleep 5;
echo Creating source and destination databases:;
docker exec -it -d my_postgres_1 psql -U root -c "create database my_database_1";
docker exec -it -d my_postgres_2 psql -U root -c "create database my_database_2";
docker cp ./dss.ddl my_postgres_1:/;
docker cp ./dss.ddl my_postgres_2:/;
docker exec -it -d my_postgres_1 psql my_database_1 -f dss.ddl;
docker exec -it -d my_postgres_2 psql my_database_2 -f dss.ddl;
echo Popullating destination database with data;
docker cp ./tbl my_postgres_1:/;
docker exec -it my_postgres_1 psql my_database_1 -c "\copy customer FROM '/tbl/customer.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy lineitem FROM '/tbl/lineitem.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy nation FROM '/tbl/nation.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy orders FROM '/tbl/orders.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy part FROM '/tbl/part.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy partsupp FROM '/tbl/partsupp.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy region FROM '/tbl/region.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy supplier FROM '/tbl/supplier.tbl' CSV DELIMITER '|'";
