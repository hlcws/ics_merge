#!/bin/sh
#check if conf file has been specified
if [ -z "$1" ]; then
    echo 'Please specify config file with $temp_dir and $publish_dir'
    exit 0
fi

if [ -z "$2" ]; then
    echo 'Please specify a list of calendars. Syntax: category url, e.g. session https://contoso.com/sessions.ics'
    exit 0
fi


#include conf from argument which gives us $temp_dir and $publish_dir
. $1

tempcal_path="${temp_dir}tempcal.ics"
merge_path="${temp_dir}he-merge.ics"
publish_path="${publish_dir}he-merge.ics"

#init merged calendar
printf "BEGIN:VCALENDAR
PRODID:-//Hardedge Merge//
VERSION:2.0
X-WR-CALNAME:Hardedge
" > $merge_path

#loop through calendars

uid=0
while read line
do
        #increment UID prefix
        uid=$((uid+1))
        #use posix to split the line into category and URL
        category=${line% *}
        url=${line#* }
        echo $category
        #download the calendar ICS to a tempdir
        wget -q -O $tempcal_path $url
        #add category according to calendar.conf
        gawk -v cat="$category" -i inplace '/END:VEVENT/{print"CATEGORIES: "cat}1' $tempcal_path
        #generate UID
        sed -i "s/@forum.hardedge.org/@$uid.hardedge.org/" $tempcal_path
        #cleanup date format
        sed -i 's/DTSTART;VALUE=DATE:/DTSTART:/' $tempcal_path
        #append and use the awk from $currentyear
        awk -f $currentyear $tempcal_path >> $merge_path
done < "$2"

#close the ics
echo "END:VCALENDAR" >> $merge_path

#remove blank lines
sed -i '/^\s*$/d' $merge_path

#correct formatting (CR)
unix2dos -q $merge_path

#publish
cp $merge_path $publish_path
#optional
chown www-data:www-data $publish_path
