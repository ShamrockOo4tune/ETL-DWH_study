import psycopg2


tables = ['nation', 'region', 'part', 'supplier', 'partsupp', 'customer', 'orders', 'lineitem']
conn_string = "host='localhost' port=54320 dbname='my_database' user='root' password='postgres'"
for table in tables:
    with psycopg2.connect(conn_string) as conn, conn.cursor() as cursor:
        q = f"COPY {table} TO STDOUT WITH DELIMITER ',' CSV HEADER;"
        with open(f'{table}.csv', 'w') as f:
            cursor.copy_expert(q, f)

