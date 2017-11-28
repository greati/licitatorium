import json

data = json.load(open('json/contratos/aditivos.json'))
l = data['_embbeded']
with open('aditivos3.json', 'a') as f:
	f.write('{"_embedded":{"aditivos":[')
	for i,k in enumerate(l):
		if '_embedded' in k:
			json.dump(k['_embedded']['aditivos'],f)
		else:
			print(k)
	f.write(']}}')
		
