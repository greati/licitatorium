import MySQLdb
import json
import argparse
import urllib.request

ap = argparse.ArgumentParser()
ap.add_argument('-t', '--table', required=True, help='Table name')
ap.add_argument('-j', '--jsonpath', required=True, help='Path to JSON file')
ap.add_argument('-u', '--dbuser', required=True, help='Database user')
ap.add_argument('-p', '--dbpasswd', required=True, help='Database password')
ap.add_argument('-hst', '--dbhost', required=True, help='Database host')
ap.add_argument('-n', '--dbname', required=True, help='Database name')
ap.add_argument('-s', '--save', required=True, help='Path to save the sql script')
ap.add_argument('-w', '--web', required=True, help='Is the JSON in the web? y/n')
ap.add_argument('-o', '--offset', required=False, help='The offset')
ap.add_argument('-c', '--count', required=False, help='Number of elements')

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

count = 0
offset = 0

if (args['web']=='y'):
    if ('offset' in args and 'count' in args):
        offset = int(args['offset'])
        count = int(args['count'])
    else:
        raise Exception('If it is a web url, define a count and an offset!')
    if (offset == 0):
        raise Exception('You must define a positive offset.')
    urls = []    
    i = 0
    while(i <= count):
        urls.append(json_url + '?offset=' + str(i))
        i += offset

# SQL to save 
insert_sql_script = ''
insert_sql_script_file = open(args['save'], 'a')

for j,u in enumerate(urls):
    if (args['web']=='y'):
        url = urllib.request.urlopen(u)
        json_data = json.loads(url.read().decode('utf-8'))
    else:
        json_data = json.load(open(u))

    # Data of interest
    for key, value in json_data['_embedded'].items():
        json_data_dict = value #json_data['_embedded'].itervalues().next();

    print('[INFO] Done!')

    print('[INFO] Generating SQL script...')

    for i in range(len(json_data_dict)):
        print('Processing row number', j*offset + i)
        identifier = json_data_dict[i]['identificador']
        url_identifier = 'http://compras.dados.gov.br/licitacoes/doc/licitacao/'+identifier +'.json'
        url_identifier_loader = urllib.request.urlopen(url_identifier)
        json_data_lic = json.loads(url_identifier_loader.read().decode('utf-8'))
        values = dict()
        for s in column_names:
            if (s in json_data_lic):
                values[s] = json_data_lic[s];
                if (type(values[s]) is str):
                    values[s] = values[s].strip()
                    values[s] = values[s].replace("'","")
                if (str(values[s]).lower() == 'true'): values[s] = '1'
                elif (str(values[s]).lower() == 'false'): values[s] = '0'
            else:
                values[s] = 'NULL'
        insert_sql_script += 'INSERT INTO ' + args['table'] + '(' + ','.join(column_names) + ') VALUES (' + ','.join("'{0}'".format(w) for w in (map(str, values.values()))) + ')' + ';\n'
        print('Done!')

    insert_sql_script_file.write(insert_sql_script)

print('[INFO] Finished successfully.')

cnx.close()
