from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas as pd
#import re
#from urllib.parse import urlencode
#from urllib.error import HTTPError

uasgs_url = "http://www.comprasnet.gov.br/livre/uasg/Catalogo_Resp.asp"
response = urlopen(uasgs_url)
html = response.read()

soup = BeautifulSoup(html, 'html.parser')
uasgs = []
first_tag = 7
last_tag = 11095
for tr_tag in soup.find_all('tr')[first_tag:last_tag]:
	uasg_data = {}

	tds = tr_tag.find_all('td')
	uasg_data['id'] = tds[0].string.strip()
	uasg_data['nome'] = tds[1].string.strip()
	uasg_data['sigla_uf'] = tds[2].a.string

	uasgs.append(uasg_data)


table = pd.DataFrame(data=uasgs, dtype=str, columns=['id', 'nome', 'sigla_uf'])
table.to_json("uasgs.json", orient='records')