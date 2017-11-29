import re
from bs4 import BeautifulSoup
from urllib.request import urlopen
#from urllib.parse import urlencode
#from urllib.error import HTTPError
import pandas as pd

uasgs_url = "http://www.comprasnet.gov.br/livre/uasg/Catalogo_Resp.asp"
response = urlopen(uasgs_url)
html = response.read()

# get all uasg ids from uasgs_url
soup = BeautifulSoup(html, 'html.parser')
id_ex = "coduasg=([0-9]+)"
uasg_ids = []
for a_tag in soup.find_all('a'):
	link = a_tag.get('href')
	uasg_id = re.compile(id_ex).search(link).group(1)
	uasg_ids.append(uasg_id)

table = pd.DataFrame(data=uasg_ids, dtype=str)
table.to_csv("uasgs.csv")