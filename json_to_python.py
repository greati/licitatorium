import json

data = json.load(open('aditivos.json'))
for k in data:
	print(k)
