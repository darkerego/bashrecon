#!/bin/bash
#######################################
# Bash Network Reconnaissance Script  #
# DarkerEgo's Bash Snippets, GPL 2015 #
#######################################

sftpUSER="user"
sftpHOST="hostname"
sftpDIR="directory"

OUTPUT="netenv.$(hostname).$(date +'%d-%m-%y').html"
TITLE="Bash Network Reconnaissance Results"
RIGHT_NOW=$(date +"%x %r %Z")
pubIP=$(curl ipreturn.tk)
WlocIP=$(/sbin/ifconfig wlan0 | grep Mask | cut -d ':' -f2 | cut -d " " -f1)
ElocIP=$(/sbin/ifconfig eth0 | grep Mask | cut -d ':' -f2 | cut -d " " -f1)
ElocSN=$(echo ${ElocIP} | cut -d "." -f -3 | sed 's/$/.*/')
WlocSN=$(echo ${WlocIP} | cut -d "." -f -3 | sed 's/$/.*/')



function pub_ipinfo(){

	echo "<h3> Nmap results for public facing IP </h3>"
	echo "<pre>"
	nmap -sV -Pn -F ${pubIP}
	echo "</pre>"
}

function wf_ipinfo(){

if [[ ${WlocIP} != "" ]]; then

	echo "<h3> Nmap results for wifi IP </h3>"
	echo "<pre>"
	nmap -sV -F ${WlocSN}
	echo "</pre>"
	
else
	echo "Wireless not available."
fi
}

function eth_ipinfo(){

if [[ ${ElocIP} != "" ]]; then

	echo "<h3> Nmap results for eth IP </h3>"
	echo "<pre>"
	nmap -sV -F ${ElocSN}
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

function phone_HOME(){
if [ ! -f batch ];then

cat << 'EOF' >> batch
        put netenv*.html
EOF

fi

sftp -b batch $sftpUSER@$sftpHOST:/$sftpDIR


}


write_page > $OUTPUT
phone_HOME


exit
