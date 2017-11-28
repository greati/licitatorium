import MySQLdb
import json
import argparse


ap = argparse.ArgumentParser()
ap.add_argument('-t', '--table', required=True, help='Table name')
ap.add_argument('-j', '--jsonpath', required=True, help='Path to JSON file')
ap.add_argument('-u', '--dbuser', required=True, help='Database user')
ap.add_argument('-p', '--dbpasswd', required=True, help='Database password')
ap.add_argument('-hst', '--dbhost', required=True, help='Database host')
ap.add_argument('-n', '--dbname', required=True, help='Database name')
ap.add_argument('-s', '--save', required=True, help='Path to save the sql script')

args = vars(ap.parse_args())

print('[INFO] Connecting to database ' + args['dbname'] + '...')

cnx = MySQLdb.connect(user=args['dbuser'], passwd=args['dbpasswd'], 
                                host=args['dbhost'], db=args['dbname'])
print('[INFO] Done!')

cur = cnx.cursor()

print('[INFO] Gathering column names from ' + args['table'] + '...')

cur.execute("SHOW columns FROM " + args['table'])

columns = cur.fetchall()

column_names = [i[0] for i in columns]

print('[INFO] Done!')

json_url = args['jsonpath']

print('[INFO] Loading JSON file from ' + json_url + '...')

json_data = json.load(open(json_url))

# Data of interest
for key, value in json_data['_embedded'].items():
    json_data_dict = value #json_data['_embedded'].itervalues().next();

print('[INFO] Done!')

print('[INFO] Generating SQL script...')

# SQL to save 
insert_sql_script = ''

for i in range(len(json_data_dict)):
    print('Processing row number', i)
    values = dict()
    for s in column_names:
        values[s] = json_data_dict[i][s];
        if (str(values[s]).lower() == 'true'): values[s] = '1'
        elif (str(values[s]).lower() == 'false'): values[s] = '0'
    insert_sql_script += 'INSERT INTO ' + args['table'] + '(' + ','.join(column_names) + ') VALUES (' + ','.join("'{0}'".format(w) for w in (map(str, values.values()))) + ')' + ';\n'
    print('Done!')

insert_sql_script_file = open(args['save'], 'w')
insert_sql_script_file.write(insert_sql_script)

print('[INFO] Finished successfully.')

cnx.close()
