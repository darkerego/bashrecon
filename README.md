# bashrecon: A Network Reconnaissance script written in BASH
Simple network reconnaissance script written in bash.

# Description
This is a portable shell script that discovers information about the users network enviroment. First the script discovers the users current public IP address by using curl to grab a web page off a server that returns the clients IP address via php. Next, a little bit of grep, cut, and sed magic grabs the LAN ip address of both the eth0 and wlan0 interfaces (if available and online). Finally, the script utilizes nmap to scan both the public facing IP address and the LAN subnet. All of the gathered information is printed to an HTML page and sent to the admin's server via sftp.

# Possible Uses
* Could be used as an anti-theft measure, by running it as cron job and having the results sftpd back to the sysadmin. 
* As a piece of a hacky replacement for dynamic dns, ie to track a changing IP address.
* As a piece of a wrapper script for some shellcode, who knows. Use your imagination.
