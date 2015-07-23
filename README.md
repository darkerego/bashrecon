# bashrecon
Simple network reconnaissance script written in bash.

# Description
This is a portable shell script that discovers information about the users network enviroment. First the script discovers the users current public IP address by using curl to grab a web page off a server that returns the clients IP address via php. Next, a little bit of grep, cut, and sed magic grabs the LAN ip address of both the eth0 and wlan0 interfaces (if available and online). Finally, the script utilizes nmap to scan both the public facing IP address and the LAN subnet. All of the gathered information is printed to an HTML page. 

# Possible Uses
Could be used as an anti-theft measure, by running it as cron job and having the results emailed back to the sysadmin. Future versions might include that feature without the need for cron, and maybe an option to open an encrypted reverse shell if the system is on a network that it should not be. Feel free to fork and innovate as always.
