import json
import requests
import itertools


base_url = 'http://compras.dados.gov.br/contratos/id/contrato/'
url_f = '{}/aditivos.json'

def iterate_request(base_url, url_f, params): 
	l = set()
	for i in  list(list(itertools.product(*params))):
		url_f2 = url_f
		u = url_f2.format(*i)
		u = base_url + u
		l.add(u)
	return l

def request_url(name,base_url, url_f, params):
	l = iterate_request(base_url,url_f, params)
	for i in l:
		r = requests.get(i)
		data = r.json()
		with open(name, 'a') as f:
			json.dump(data,f)	
l = []
with open('identificadores') as f:
	for line in f:
		l.append(int(line))
request_url('aditivos.json', base_url, url_f, [l])
