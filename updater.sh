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
         /tmp/download_url.txt
       echo "Downloading $(cat /tmp/download_url.txt)"
       curl -L $(cat /tmp/download_url.txt) > /home/galileo/.galileo-ide/galileo_ide.tar.gz
       tar -xvf /home/galileo/.galileo-ide/galileo_ide.tar.gz -C /home/galileo/
       rm /home/galileo/.galileo-ide/galileo_ide.tar.gz
       nohup supervisorctl restart galileo-ide > /tmp/nohup.out
   }

   diff -w --strip-trailing-cr /home/galileo/.galileo-ide/latest_ide_version.txt /home/galileo/.galileo-ide/current_ide_version.txt && \
     echo '### No Update Detected ###' || \
     download_update
else
   echo "----------------------------------------"
   echo "-----Could not detect IDE version-------"
   echo "----------------------------------------"
fi