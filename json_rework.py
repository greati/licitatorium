import json

data = json.load(open('aditivos.json'))
l = data['_embbeded']
with open('aditivos2.json', 'a') as f:
	f.write('{"_embbeded":{"aditivos":[')
	for i,k in enumerate(l):
		if i != 0:
			f.write(",")
		json.dump(k,f)
	f.write(']}}')
		
