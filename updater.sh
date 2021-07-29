#!/bin/bash

if test -e /home/galileo/.galileo-ide/current_ide_version.txt; then
   curl \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/repos/GoHypernet/Galileo-IDE/releases/latest | \
     grep "tag_name" |\
     sed 's/"tag_name": "//g' | sed 's/",//g' | sed -r 's/\s+//g' | sed ':a;N;$!ba;s/\n//g' > \
     /home/galileo/.galileo-ide/latest_ide_version.txt
   
   function download_update() {
       curl \
         -H "Accept: application/vnd.github.v3+json" \
         https://api.github.com/repos/GoHypernet/Galileo-IDE/releases/latest | \
         grep "browser_download_url" |\
         sed 's/"browser_download_url": "//g' | sed 's/"//g' | sed -r 's/\s+//g' | sed ':a;N;$!ba;s/\n//g' > \
         download_url.txt
       echo "Downlaoding $(cat download_url.txt)"
       curl -L $(cat download_url.txt) > /home/galileo/.galileo-ide/galileo_ide.tar.gz
       tar -xvf /home/galileo/.galileo-ide/galileo_ide.tar.gz -C /home/galileo/.galileo-ide
       rm /home/galileo/.galileo-ide/galileo_ide.tar.gz
       nohup supervisorctl restart galileo-ide > /tmp/nohup.out
   }

   cmp --silent /home/galileo/.galileo-ide/latest_ide_version.txt /home/galileo/.galileo-ide/current_ide_version.txt && \
     echo '### No Update Detected ###' || \
     download_update
else
   echo "----------------------------------------"
   echo "-----Could not detect IDE version-------"
   echo "----------------------------------------"
fi