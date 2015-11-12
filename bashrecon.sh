#!/bin/bash
#####################################################
# Bash Network Reconnaissance Script * Version 3.0  #
# 	DarkerEgo's Bash Snippets, GPL 2015 	    #
#####################################################

# A Linux shell script to compile information about a hosts network enviroment and
# than send it to a server over sftp. Possible uses include using as an alternative
# to dynamic dns services, or perhaps as an anti-theft in shared computing enviroments.


# --DEPENDS: nmap, curl, an sftp server
# --RECOMMENDS: secure-delete





# Edit SFTP Variables:
sftp="et_host" # sftp config HOST referance as in ~/.ssh/config
sftpDIR="/public_html" # writable dir
username=$(whoami)
#
#######################
RIGHT_NOW=$(date +"%Y-%m-%d_%H:%M:%S")
#RIGHT_NOW=$(date +"%x %r %Z") # alternate date format
workDIR="~/$username/.netrecon" # where to store temporary files
OUTPUT="netenv.$(hostname).$(date +'%d-%m-%y').html" # will be deleted after transport
TITLE="Bash Network Reconnaissance Results" # output title (ouputs in html format)


########################
pubIP=$(curl ipreturn.tk/raw.php) # grab public facing ip
pIP=$(echo ${pubIP})
INTFACES=$(/sbin/ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d') # get nics
intIPS=$(for i in ${INTFACES}; do /sbin/ifconfig $i | grep Mask | cut -d ':' -f2 | cut -d " " -f1; done) # get local ips
intSNS=$(for i in ${intIPS}; do echo $i | cut -d "." -f -3 | sed 's/$/.*/'; done) # & turn them into nmap readable subnets
sn_RESULTS=$(for i in ${intSNS}; do nmap -sV -F $i; done) # nmap localsubnets
pi_RESULTS=$(nmap -sV -F -Pn ${pubIP}) # mnap outgoing ip
########################

# create work dir, outfile, delete old files
function prep_VARS(){

if [[ ! -d $workDIR ]];then
	mkdir $workDIR
fi

if [[ -f $workDIR/$OUTPUT ]];then
	srm $workDIR/$OUTPUT || rm $workDIR/$OUTPUT

fi
touch $workDIR/$OUTPUT
}

# write the page

function write_page(){


cat << _EOF_ 

<html>
  <head>
      <title>$TITLE</title>
  </head>

  <body bgcolor="black" text="white">
      <h1>$TITLE</h1>
      <h2>$RIGHT_NOW</h2>
	<h3> Local Subnet Scan Results: </h3>
	<p> Public IP: </p>
	<pre>
		${pIP}
	</pre>
	<p> Local Subnet Scans: </p>
	<pre>
		${sn_RESULTS}
	</pre>
	<p> Public IP Scan</p>
	<pre>
		${pi_RESULTS}
	</pre>
  </body>
</html>
_EOF_

}
# phone home via sftp
function phone_HOME(){

cd $workDIR

if [[ ! -f $workDIR/batch ]];then

cat << 'EOF' >> $workDIR/batch
        put netenv*.html
EOF

fi

cd $workDIR
sftp -b batch $sftp:/$sftpDIR


}

function clean_UP(){
# if secure-delete is not available, revert to rm
srm -r $workDIR || rm -rf $workDIR
}


prep_VARS
write_page >> $workDIR/$OUTPUT
phone_HOME;sleep 5 # make sure things are processed in the right order
clean_UP
exit
