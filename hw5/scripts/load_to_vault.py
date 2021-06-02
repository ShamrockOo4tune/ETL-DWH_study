import psycopg2

tables = ['partsupp', 'customer', 'nation', 'region', 'part', 'supplier', 'orders', 'lineitem']
sql_list = ['create table if not exists partsupp (ps_partkey integer, ps_suppkey integer, ps_availqty integer, ps_supplycost numeric, ps_comment text);', 'create table if not exists customer (c_custkey integer,c_name character varying(20),c_address character varying(60),c_nationkey integer,c_phone character varying(20),c_acctbal numeric,c_mktsegment character varying(20),c_comment text);', 'create table if not exists nation (n_nationkey integer, n_name varchar(20), n_regionkey integer, n_comment text);', 'create table if not exists region (r_regionkey integer,r_name character varying(20),r_comment text);', 'create table if not exists part (p_partkey integer,p_name character varying(50),p_mfgr character varying(20),p_brand character varying(50) ,p_type character varying(50),p_size integer,p_container character varying(20), p_retailprice numeric, p_comment character varying(50));', 'create table if not exists lineitem (l_orderkey integer,l_partkey integer,l_suppkey integer,l_linenumber integer,l_quantity numeric,l_extendedprice numeric,l_discount numeric,l_tax numeric,l_returnflag character varying(10),l_linestatus character varying(20), l_shipdate date,l_commitdate date,l_receiptdate date,l_shipinstruct character varying(60),l_shipmode character varying(20),l_comment text);', 'create table if not exists supplier (s_suppkey integer,s_name text,s_address character varying(40),s_nationkey integer,s_phone varchar(20),s_acctbal numeric,s_comment text);', 'create table if not exists orders (o_orderkey integer,o_custkey integer,o_orderstatus character varying(20),o_totalprice numeric,o_orderdate date,o_orderpriority character varying(20),o_clerk character varying(30),o_shippriority integer,o_comment text);']
conn_string = "host='localhost' port=5433 dbname='my_database2' user='root' password='postgres'"
with psycopg2.connect(conn_string) as conn, conn.cursor() as cursor:
    for sql in sql_list:
        cursor.execute(sql) 
    for table_name in tables:
        q = f"COPY {table_name} from STDIN WITH DELIMITER ',' CSV HEADER;"
        with open(f'{table_name}.csv', 'r') as f:
            cursor.copy_expert(q, f)

