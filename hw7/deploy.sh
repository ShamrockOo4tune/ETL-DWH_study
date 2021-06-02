#!/bin/bash

#echo Shuting down containers and erasing volumes:;
#docker-compose down;
#docker volume rm hw7_my_db1data;
#docker volume rm hw7_my_db2data;
#echo Starting docker containers deployment:;
#docker-compose up -d;
#sleep 5;
echo Creating source and destination databases:;
docker exec -it my_postgres_1 psql -U root -c "drop database if exists my_database_1;";
docker exec -it my_postgres_2 psql -U root -c "drop database if exists my_database_2;";
docker exec -it my_postgres_1 psql -U root -c "create database my_database_1";
docker exec -it my_postgres_2 psql -U root -c "create database my_database_2";
docker cp ./dss.ddl my_postgres_1:/;
docker cp ./dss.ddl my_postgres_2:/;
docker exec -it my_postgres_1 psql my_database_1 -f dss.ddl;
docker exec -it my_postgres_2 psql my_database_2 -f dss.ddl;
echo check:
docker exec -it my_postgres_1 psql my_database_1 -U root -c "\dt;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "\dt;";

echo Popullating source database with data;
docker cp ./tbl my_postgres_1:/;
docker exec -it my_postgres_1 psql my_database_1 -c "\copy customer FROM '/tbl/customer.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy lineitem FROM '/tbl/lineitem.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy nation FROM '/tbl/nation.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy orders FROM '/tbl/orders.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy part FROM '/tbl/part.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy partsupp FROM '/tbl/partsupp.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy region FROM '/tbl/region.tbl' CSV DELIMITER '|'";
docker exec -it my_postgres_1 psql my_database_1 -c "\copy supplier FROM '/tbl/supplier.tbl' CSV DELIMITER '|'";
echo Create log table in my_data_base_2:;
docker exec -it my_postgres_2 psql my_database_2 -U root -c "create table log (
       source_launch_id    int
     , target_schema       text
     , target_table        text  
     , target_launch_id    int
     , processed_dttm      timestamp default now()
     , row_count           int
     , duration            interval
     , load_date           date);";
echo Create statistic table in my_database_2:;
docker exec -it my_postgres_2 psql my_database_2 -U root -c "create table statistic (
       table_name     text
     , column_name    text
     , cnt_nulls      int
     , cnt_all        int
     , load_date      date);";

echo Add launch_id \(int\) and effective_dttm \(timestamp\) default now;
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table customer add column c_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table customer add column c_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table lineitem add column l_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table lineitem add column l_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table nation add column n_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table nation add column n_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table orders add column o_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table orders add column o_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table part add column p_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table part add column p_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table partsupp add column ps_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table partsupp add column ps_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table region add column r_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table region add column r_effective_dttm timestamp default now();";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table supplier add column s_launch_id int;";
docker exec -it my_postgres_2 psql my_database_2 -U root -c "alter table supplier add column s_effective_dttm timestamp default now();";

docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table customer add column c_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table customer add column c_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table lineitem add column l_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table lineitem add column l_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table nation add column n_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table nation add column n_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table orders add column o_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table orders add column o_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table part add column p_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table part add column p_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table partsupp add column ps_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table partsupp add column ps_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table region add column r_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table region add column r_effective_dttm timestamp default now();";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table supplier add column s_launch_id int;";
docker exec -it my_postgres_1 psql my_database_1 -U root -c "alter table supplier add column s_effective_dttm timestamp default now();";
