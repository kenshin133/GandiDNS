##The purpose of this script is to check the IP by hitting ipchicken and update dns accordingly using the gandi dns api
#the use for this is for non-static IP servers (such as homeservers) could potentially call out and update the DNS in gandi if the IP changes.
#It is meant to run around every 15 minutes but this could easily be any length of time.

#Variables
#This can be aquired (after being created) inside your gandi panel
APIkey=FILL THIS IN WITH YOUR OWN APIkey
#this curls IPchicken and gets the IP listed on the webpage.
IP=$(curl -s -L http://ipchicken.com | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#this would be your gandi domain, when you get your gandiAPIkey you should also see this
domain=Youdomain.com


#records to update every 15 minutes, in production case it should be @ and cloud or whatever your subdomains are. 
RECORDS=(@ cloud)
#loop through the records and update the IP in gandi to point to your server.
for i in "${RECORDS[@]}";do curl -v -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $APIkey" -d '{"rrset_values":["'$IP'"]}' https://dns.api.gandi.net/api/v5/domains/$domain/records/$i/A; done


##TODO
#Add logging to output last IP, last ran time, etc
#add local check update check to keep apicalls to a minimum

