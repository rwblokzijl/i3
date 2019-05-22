#!/usr/bin/python3

import mechanicalsoup

import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# disable warnings about the https verify=False, which is needed because of shitty certs? idfk, just dont reuse an
# important password for the site
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# get login info from file
credentials_file = open("/home/bloodyfool/laundrylogin.creds", "r")
user_email = credentials_file.readline().strip()
password = credentials_file.readline().strip()

# actual site interaction
browser = mechanicalsoup.StatefulBrowser()

# get the login page
response = browser.open("https://duwo.multiposs.nl/login/index.php", verify=False)

# fill and submit the login form
form = browser.select_form('form#FormLogin')
form['UserInput'] = user_email
form['PwdInput'] = password
browser.submit_selected()

# "activate" the site by going to the link returned after the login
url = "https://duwo.multiposs.nl" + browser.get_current_page().find('script').text.split("\'")[1].split("..")[1]
response = browser.open(url, verify=False)

# get the Machine Availability "sub" page
response = browser.open("https://duwo.multiposs.nl/MachineAvailability.php", verify=False)

# parse it for data
page = browser.get_current_page()

# get the second and third row of the only table in the page
wash_row, dry_row = page.find_all('tr')[1:3]

# if there are no machines available the row has a <p> with class="TxtNotAvailable" else it has class="TxtAvailable"
if(wash_row.find('p', {'class': 'TxtAvailable'})):
    wash_p = wash_row.find('p')  # wash_p.text = "Available :2"
    wash = wash_p.text.split(":")[1]
else:
    wash = '0'

# the same for dryers
if(dry_row.find('p', {'class': 'TxtAvailable'})):
    dry_p = dry_row.find('p')  # dry_p.text = "Available :2"
    dry = dry_p.text.split(":")[1]
else:
    dry = '0'

output = "wash/dry: (" + wash + "/" + dry + ")"

print(output)
print(output)
if(int(wash) == 0):
    pass
elif(int(wash) == 1):
    pass
elif(int(wash) == 2):
    print("#FABD2F")
elif(int(wash) == 3):
    print("#B8BB26")
elif(int(wash) == 4):
    print("#B8BB26")
