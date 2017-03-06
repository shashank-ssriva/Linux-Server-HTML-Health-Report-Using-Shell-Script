#! /bin/bash
#Author : - Shashank Srivastava

#Declaring variables
#set -x
os_name=`uname -v | awk {'print$1'} | cut -f2 -d'-'`
upt=`uptime | awk {'print$3'} | cut -f1 -d','`
ip_add=`ifconfig | grep "inet addr" | head -2 | tail -1 | awk {'print$2'} | cut -f2 -d:`
num_proc=`ps -ef | wc -l`
root_fs_pc=`df -h /dev/sda1 | tail -1 | awk '{print$5}'`
total_root_size=`df -h /dev/sda1 | tail -1 | awk '{print$2}'`
load_avg=`uptime | cut -f5 -d':'`
ram_usage=`free -m | head -2 | tail -1 | awk {'print$3'}`
ram_total=`free -m | head -2 | tail -1 | awk {'print$2'}`
inode=`df -i / | head -2 | tail -1 | awk {'print$5'}`
html="Server-Health-Report-`hostname`-`date +%y%m%d`-`date +%H%M`.html"
email_add="change it to yours"
#redirecting details of disk-space usage to a text file.
for i in `ls /home`; do du -sh /home/$i/* | sort -nr | grep G; done > /tmp/dir.txt

#Generating HTML file by echoing HTML tags.
echo "<html>" >> $html
echo "<link rel="stylesheet" href="https://unpkg.com/purecss@0.6.2/build/pure-min.css">" >> $html
echo "<body>" >> $html
echo "<fieldset>" >> $html
echo "<center>" >> $html
echo "<h2>Linux Server Report" >> $html
echo "<h3><legend>Script authored by Shashank Srivastava</legend></h3>" >> $html
echo "</center>" >> $html
echo "</fieldset>" >> $html
echo "<br>" >> $html
echo "<center>" >> $html
echo "<h2>OS Details : </h2>" >> $html
echo "<table class="pure-table">" >> $html
echo "<thead>" >> $html
echo "<tr>" >> $html
echo "<th>OS Name</th>" >> $html
echo "<th>IP Address</th>" >> $html
echo "<th>Uptime</th>" >> $html
echo "</tr>" >> $html
echo "</thead>" >> $html
echo "<tbody>" >> $html
echo "<tr>" >> $html
echo "<td>$os_name</td>" >> $html
echo "<td>$ip_add</td>" >> $html
echo "<td>$upt</td>" >> $html
echo "</tr>" >> $html
echo "</tbody>" >> $html
echo "</table>" >> $html
echo "<h2>Resources Utilization : </h2>" >> $html
echo "<br>" >> $html
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
echo "<h2>Culprit Directories (Eating up disk space) : </h2>" >> $html
echo "<br>" >> $html
echo "<table class="pure-table">" >> $html
echo "<thead>" >> $html
echo "<tr>" >> $html
echo "<th>Size</th>" >> $html
echo "<th>Name</th>" >> $html
echo "</tr>" >> $html
echo "</thead>" >> $html
echo "<tr>" >> $html
#looping through the text data contained inside /tmp/dir.txt.
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

#Sending Email to the user
cat $html | mail -s "`hostname` - Daily System Health Report. PFA the file." $email_add
