#! /bin/bash
#Author : - Shashank Srivastava
#Date : - 7 March, 2017

#Checking if this script is being executed as ROOT. For maintaining proper directory structure, this script must be run from a root user.
if [ $EUID != 0 ]
then
  echo "Please run this script as root so as to see all the details! Better run with sudo."
  exit 1
fi
#Declaring variables
#set -x
os_name=`uname -v | awk {'print$1'} | cut -f2 -d'-'`
upt=`uptime | awk {'print$3'} | cut -f1 -d','`
ip_add=`ifconfig | grep "inet addr" | head -2 | tail -1 | awk {'print$2'} | cut -f2 -d:`
num_proc=`ps -ef | wc -l`
root_fs_pc=`df -h /dev/sda1 | tail -1 | awk '{print$5}'`
total_root_size=`df -h /dev/sda1 | tail -1 | awk '{print$2}'`
#Disabled below load average extraction since for freshly booted servers, it will correspond to -f4.
#load_avg=`uptime | cut -f5 -d':'`
load_avg=`cat /proc/loadavg  | awk {'print$1,$2,$3'}`
ram_usage=`free -m | head -2 | tail -1 | awk {'print$3'}`
ram_total=`free -m | head -2 | tail -1 | awk {'print$2'}`
inode=`df -i / | head -2 | tail -1 | awk {'print$5'}`
os_version=`uname -v | cut -f2 -d'~' | awk {'print$1'} | cut -f1 -d'-' | cut -c 1-5`
#Creating a directory if it doesn't exist to store reports first, for easy maintenance.
if [ ! -d ${HOME}/health_reports ]
then
  mkdir ${HOME}/health_reports
fi
html="${HOME}/health_reports/Server-Health-Report-`hostname`-`date +%y%m%d`-`date +%H%M`.html"
email_add="change this to yours"
for i in `ls /home`; do sudo du -sh /home/$i/* | sort -nr | grep G; done > /tmp/dir.txt
#Generating HTML file
echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">" >> $html
echo "<html>" >> $html
echo "<head>" >> $html
echo "<link rel="stylesheet" href="https://unpkg.com/purecss@0.6.2/build/pure-min.css">" >> $html
echo "<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">" >> $html
echo "<style>" >> $html
echo -e "h1 {
    font-family: "Avant Garde", Avantgarde, "Century Gothic", CenturyGothic, "AppleGothic", sans-serif;
    font-size: 70px;
    padding: 45px 20px;
    text-align: center;
    text-transform: uppercase;
    text-rendering: optimizeLegibility;
  }" >> $html
  echo -e "h2 {
    font-family: "Avant Garde", Avantgarde, "Century Gothic", CenturyGothic, "AppleGothic", sans-serif;
    font-size: 30px;
    padding: 45px 20px;
    text-align: center;
    text-transform: uppercase;
    text-rendering: optimizeLegibility;
  }" >> $html
  echo -e "h1.elegantshadow {
    color: #131313;
    background-color: #e7e5e4;
    letter-spacing: .15em;
    text-shadow: 1px -1px 0 #767676, -1px 2px 1px #737272, -2px 4px 1px #767474, -3px 6px 1px #787777, -4px 8px 1px #7b7a7a, -5px 10px 1px #7f7d7d, -6px 12px 1px #828181, -7px 14px 1px #868585, -8px 16px 1px #8b8a89, -9px 18px 1px #8f8e8d, -10px 20px 1px #949392, -11px 22px 1px #999897, -12px 24px 1px #9e9c9c, -13px 26px 1px #a3a1a1, -14px 28px 1px #a8a6a6, -15px 30px 1px #adabab, -16px 32px 1px #b2b1b0, -17px 34px 1px #b7b6b5, -18px 36px 1px #bcbbba, -19px 38px 1px #c1bfbf, -20px 40px 1px #c6c4c4, -21px 42px 1px #cbc9c8, -22px 44px 1px #cfcdcd, -23px 46px 1px #d4d2d1, -24px 48px 1px #d8d6d5, -25px 50px 1px #dbdad9, -26px 52px 1px #dfdddc, -27px 54px 1px #e2e0df, -28px 56px 1px #e4e3e2;
  }" >> $html
  echo -e "h2.deepshadow {
  color: #e0dfdc;
  background-color: #333;
  letter-spacing: .1em;
  text-shadow: 0 -1px 0 #fff, 0 1px 0 #2e2e2e, 0 2px 0 #2c2c2c, 0 3px 0 #2a2a2a, 0 4px 0 #282828, 0 5px 0 #262626, 0 6px 0 #242424, 0 7px 0 #222, 0 8px 0 #202020, 0 9px 0 #1e1e1e, 0 10px 0 #1c1c1c, 0 11px 0 #1a1a1a, 0 12px 0 #181818, 0 13px 0 #161616, 0 14px 0 #141414, 0 15px 0 #121212, 0 22px 30px rgba(0, 0, 0, 0.9);
}" >> $html
echo "</style>" >> $html
echo "<script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>" >> $html
echo "</head>" >> $html
echo "<body>" >> $html
echo "<center>" >> $html
echo "<h1 class='elegantshadow'>Linux Server Report</h1>" >> $html
echo "<h2 class='deepshadow'>Script authored by Shashank Srivastava</h2>" >> $html
echo "</center>" >> $html
echo "<center>" >> $html
echo "<h2>OS Details : </h2>" >> $html
echo "<table class="pure-table">" >> $html
echo "<thead>" >> $html
echo "<tr>" >> $html
echo "<th>OS Name</th>" >> $html
echo "<th>OS Version</th>" >> $html
echo "<th>IP Address</th>" >> $html
echo "<th>Uptime</th>" >> $html
echo "</tr>" >> $html
echo "</thead>" >> $html
echo "<tbody>" >> $html
echo "<tr>" >> $html
echo "<td>$os_name</td>" >> $html
echo "<td>$os_version</td>" >> $html
echo "<td>$ip_add</td>" >> $html
echo "<td>$upt</td>" >> $html
echo "</tr>" >> $html
echo "</tbody>" >> $html
echo "</table>" >> $html
echo "<h2>Resources Utilization : </h2>" >> $html
echo "<table class="pure-table">" >> $html
echo "<thead>" >> $html
echo "<tr>" >> $html
echo "<th># of Processes</th>" >> $html
echo "<th>Root FS Usage</th>" >> $html
echo "<th>Total Size of Root FS</th>" >> $html
echo "<th>Load Average</th>" >> $html
echo "<th>Used RAM(in MB)</th>" >> $html
echo "<th>Total RAM(in MB)</th>" >> $html
echo "<th>iNode Status</th>" >> $html
echo "</tr>" >> $html
echo "</thead>" >> $html
echo "<tbody>" >> $html
echo "<tr>" >> $html
echo "<td><center>$num_proc</center></td>" >> $html
echo "<td><center>$root_fs_pc</center></td>" >> $html
echo "<td><center>$total_root_size</center></td>" >> $html
echo "<td><center>$load_avg</center></td>" >> $html
echo "<td><center>$ram_usage</center></td>" >> $html
echo "<td><center>$ram_total</center></td>" >> $html
echo "<td><center>$inode</center></td>" >> $html
echo "</tr>" >> $html
echo "</tbody>" >> $html
echo "</table>" >> $html
echo "<h2>Culprit Directories(Eating up disk space) : </h2>" >> $html
echo "<table class="pure-table">" >> $html
echo "<thead>" >> $html
echo "<tr>" >> $html
echo "<th>Size</th>" >> $html
echo "<th>Name</th>" >> $html
echo "</tr>" >> $html
echo "</thead>" >> $html
echo "<tr>" >> $html
while read size name;
do
  echo "<td>$size</td>" >> $html
  echo "<td>$name</td>" >> $html
  echo "</tr>" >> $html
  echo "</tbody>" >> $html
done < /tmp/dir.txt
echo "</table>" >> $html
echo "</body>" >> $html
echo "</html>" >> $html
echo "Report has been generated in ${HOME}/health_reports with file-name = $html. Report has also been sent to $email_add."
#Sending Email to the user.
cat $html | mail -s "`hostname` - Daily System Health Report" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -a "From: Shashank Srivastava <root@shashank.com>" $email_add
