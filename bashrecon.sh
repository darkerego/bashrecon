#!/bin/bash
#######################################
# Bash Network Reconnaissance Script  #
# DarkerEgo's Bash Snippets, GPL 2015 #
#######################################
OUTPUT="netenv.$(date +'%d-%m-%y').log"
TITLE="Bash Network Reconnaissance Results"
RIGHT_NOW=$(date +"%x %r %Z")
pubIP=$(curl ipreturn.tk)
WlocIP=$(ifconfig wlan0 | grep Mask | cut -d ':' -f2 | cut -d " " -f1)
ElocIP=$(ifconfig eth0 | grep Mask | cut -d ':' -f2 | cut -d " " -f1)
ElocSN=$(echo ${ElocIP} | cut -d "." -f -3 | sed 's/$/.*/')
WlocSN=$(echo ${WlocIP} | cut -d "." -f -3 | sed 's/$/.*/')



function pub_ipinfo(){

	echo "<h3> Nmap results for public facing IP </h3>"
	echo "<pre>"
	nmap -sS -sV -Pn ${pubIP}
	echo "</pre>"
}

function wf_ipinfo(){

if [[ ${WlocIP} != "" ]]; then

	echo "<h3> Nmap results for wifi IP </h3>"
	echo "<pre>"
	nmap -sS -sV ${WlocSN}
	echo "</pre>"
	
else
	echo "Wireless not available."
fi
}

function eth_ipinfo(){

if [[ ${ElocIP} != "" ]]; then

	echo "<h3> Nmap results for eth IP </h3>"
	echo "<pre>"
	nmap -sS -sV ${ElocSN}
	echo "</pre>"
else
	echo "Ethernet not available"

fi
}

function write_page(){

cat <<- _EOF_
  <html>
  <head>
      <title>$TITLE</title>
  </head>

  <body bgcolor="black" text="white">
      <h1>$TITLE</h1>
      <p>$RIGHT_NOW</p>
      $(pub_ipinfo)
      $(wf_ipinfo)
      $(eth_ipinfo)
  </body>
  </html>
_EOF_

}




pub_ipinfo
wf_ipinfo
eth_ipinfo
write_page > net_env.html

exit
