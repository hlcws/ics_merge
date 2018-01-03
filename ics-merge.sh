#!/bin/sh
wget -O ranbat-raw.ics https://forum.hardedge.org/calendar/index.php?calendar-export/11/
wget -O turnier-raw.ics https://forum.hardedge.org/calendar/index.php?calendar-export/7/
wget -O session-raw.ics https://forum.hardedge.org/calendar/index.php?calendar-export/6/


#Add category and make UID unique with prefix
awk '/END:VEVENT/{print"CATEGORIES: Turnier"}1' turnier-raw.ics > turnier-categories.ics
sed s/@forum.hardedge.org/@turnier.hardedge.org/ < turnier-categories.ics > turnier.ics
awk '/END:VEVENT/{print"CATEGORIES: Ranbat"}1' ranbat-raw.ics > ranbat-categories.ics
sed s/@forum.hardedge.org/@ranbat.hardedge.org/ < ranbat-categories.ics > ranbat.ics
awk '/END:VEVENT/{print"CATEGORIES: Session"}1' session-raw.ics > session-categories.ics
sed s/@forum.hardedge.org/@session.hardedge.org/ < session-categories.ics > session.ics


#init merged ICS
echo "BEGIN:VCALENDAR
PRODID:-//Hardedge Merge//
VERSION:2.0
X-WR-CALNAME:Hardedge" > he-merge.ics

#append all ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' turnier.ics >> he-merge.ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' ranbat.ics >> he-merge.ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' session.ics >> he-merge.ics

#testmerge, use dos2unix instead
#cat turnier-categories.ics ranbat-categories.ics session-categories.ics >> he-merge2.ics

#close the ics
echo "END:VCALENDAR" >> he-merge.ics

#get carriage return right
dos2unix he-merge.ics

#publish
cp he-merge.ics /var/www/wordpress/
chown www-data:www-data /var/www/wordpress/he-merge.ics