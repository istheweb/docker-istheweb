#!/bin/bash
#Author Andrés Rangel
#license GPLv2

#DECLARE VARIABLES
src_dir="src/"
dest_dir="public/"
log_dir="backuperrors.txt"

#My own man pages say nothing about what 0 means, but from digging around, it seems to mean the current process group. Since the script get's it's own process group, this ends up sending SIGHUP to all the script's children, foreground and background.
#http://stackoverflow.com/questions/1644856/terminate-running-commands-when-shell-script-is-killed
trap 'kill -HUP 0' EXIT

#FUNCTION TO USE RYSNC TO BACKUP DIRECTORIES
function backup () {

if sudo rsync -avz --delete $src_dir $dest_dir  2>&1 >>$log_dir
then
sudo chown -Rv www-data:www-data $dest_dir
echo "backup succeeded $src_dir"

else
echo "rysnc failed on $src_dir"
return 1
fi
}


#CHECK IF INOTIFY-TOOLS IS INSTALLED
type -P inotifywait &>/dev/null || { echo "inotifywait command not found."; exit 1; }

#INFINITE WHILE LOOP
while true
do

#START RSYNC AND ENSURE DIR ARE UPTO DATA
backup  || exit 0

#START RSYNC AND TRIGGER BACKUP ON CHANGE
inotifywait -r -e modify,attrib,close_write,move,create,delete  --format '%T %:e %f' --timefmt '%c' $src_dir  2>&1 >>$log_dir && backup

done