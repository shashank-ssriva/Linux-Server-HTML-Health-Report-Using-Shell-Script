# Linux Server HTML Health Report (Using Shell Script)
A shell script to generate Linux Server's health report in HTML

## Introduction
SysAdmins continuoulsly need to monitor their infrastructure & while, there are numerous [Monitoring Tools](https://watilearnd2day.wordpress.com/category/server-monitoring/) available for Linux to achieve this, nothing beats the simiplicity of an HTML Report that you can generate either by executing a shell script or by tucking it inside a CRON job. My script does exactly that.

## How to use?
Just download the script & make it executable using ``chmod +x syshealth.sh``. Now you can either execute it using ``./syshealth.sh`` or put it inside a CRON job.

## Additional notes
This script also explains (*I mean, along-with having the script to perform the intended tasks, this script also serves to demonstrate how tags can be used*) how HTML tags can be used inside a shell script. You can modify it to suit your needs.
You must run this script as root so as to see full disk-usage details. Normal user can't see other home-directories & hence ``du -sh`` won't return accurate details if run as non-root.
To see what the output HTML file looks like, please see the HTML file packaged in this repository.
