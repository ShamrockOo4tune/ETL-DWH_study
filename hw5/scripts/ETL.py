import psycopg2

tables = ['partsupp', 'customer', 'nation', 'region', 'part', 'supplier', 'orders', 'lineitem']

source_conn_string = "host='localhost' port=5433 dbname='my_database' user='root' password='postgres'"
target_conn_string = "host='localhost' port=5434 dbname='my_database' user='root' password='postgres'"

with psycopg2.connect(source_conn_string) as conn, conn.cursor() as cursor:
    for table_name in tables:
        q = f"COPY {table_name} to STDOUT WITH DELIMITER ',' CSV HEADER;"
        with open(f'{table_name}.csv', 'w') as f:
            cursor.copy_expert(q, f)
            print(f'copied {table_name} to {table_name}.csv')

with psycopg2.connect(target_conn_string) as conn, conn.cursor() as cursor:
    for table_name in tables:
        q = f"COPY {table_name} FROM STDIN WITH DELIMITER ',' CSV HEADER;"
        with open(f'{table_name}.csv', 'r') as f:
            cursor.copy_expert(q, f)
            print(f'copied {table_name} from {table_name}.csv')