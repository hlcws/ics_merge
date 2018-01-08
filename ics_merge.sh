#!/bin/sh
#check if conf file has been specified
if [ -z "$1" ]; then
    echo 'Please specify config file with $spth and $www_path'
    exit 0
fi

#include conf from argument which gives us $spth and $www_path
. $1

#define absolute paths
ranbat_path="${spth}ranbat.ics"
turnier_path="${spth}turnier.ics"
session_path="${spth}session.ics"
merge_path="${spth}he-merge.ics"
target_path="${www_path}he-merge.ics"

#Get calendars
wget -O $ranbat_path https://forum.hardedge.org/calendar/index.php?calendar-export/11/
wget -O $turnier_path https://forum.hardedge.org/calendar/index.php?calendar-export/7/
wget -O $session_path https://forum.hardedge.org/calendar/index.php?calendar-export/6/

#Add category to calendars and make UID unique with prefix
gawk -i inplace '/END:VEVENT/{print"CATEGORIES: Turnier"}1' $turnier_path
sed -i 's/@forum.hardedge.org/@turnier.hardedge.org/' $turnier_path
awk -i inplace '/END:VEVENT/{print"CATEGORIES: Ranbat"}1' $ranbat_path
sed -i 's/@forum.hardedge.org/@Ranbat.hardedge.org/' $ranbat_path
awk -i inplace '/END:VEVENT/{print"CATEGORIES: Session"}1' $session_path
sed -i 's/@forum.hardedge.org/@Session.hardedge.org/' $session_path

#init merged calendar
echo "BEGIN:VCALENDAR
PRODID:-//Hardedge Merge//
VERSION:2.0
X-WR-CALNAME:Hardedge" > $merge_path

#append all calendars
awk '/BEGIN:VEVENT/,/END:VEVENT/' $turnier_path >> $merge_path
awk '/BEGIN:VEVENT/,/END:VEVENT/' $ranbat_path >> $merge_path
awk '/BEGIN:VEVENT/,/END:VEVENT/' $session_path >> $merge_path

#close the ics
echo "END:VCALENDAR" >> $merge_path

#correct formatting (CR)
dos2unix $merge_path

#remove blank lines
gawk -i inplace 'NF' $merge_path

#publish
cp $merge_path $target_path
#optional
#chown www-data:www-data $target_path

#cleanup
rm $ranbat_path $turnier_path $session_path $merge_path