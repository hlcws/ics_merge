#!/bin/sh
#Get calendars
wget -O ranbat.ics https://forum.hardedge.org/calendar/index.php?calendar-export/11/
wget -O turnier.ics https://forum.hardedge.org/calendar/index.php?calendar-export/7/
wget -O session.ics https://forum.hardedge.org/calendar/index.php?calendar-export/6/


#Add category to calendars and make UID unique with prefix
gawk -i inplace '/END:VEVENT/{print"CATEGORIES: Turnier"}1' turnier.ics
sed -i 's/@forum.hardedge.org/@turnier.hardedge.org/' turnier.ics
awk -i inplace '/END:VEVENT/{print"CATEGORIES: Ranbat"}1' ranbat.ics
sed -i 's/@forum.hardedge.org/@Ranbat.hardedge.org/' ranbat.ics
awk -i inplace '/END:VEVENT/{print"CATEGORIES: Session"}1' session.ics
sed -i 's/@forum.hardedge.org/@Session.hardedge.org/' session.ics

#init merged calendar
echo "BEGIN:VCALENDAR
PRODID:-//Hardedge Merge//
VERSION:2.0
X-WR-CALNAME:Hardedge" > he-merge.ics

#append all calendars
awk '/BEGIN:VEVENT/,/END:VEVENT/' turnier.ics >> he-merge.ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' ranbat.ics >> he-merge.ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' session.ics >> he-merge.ics

#close the ics
echo "END:VCALENDAR" >> he-merge.ics

#correct formatting (CR)
dos2unix he-merge.ics

#remove blank lines
gawk -i inplace 'NF' he-merge.ics

#publish
cp he-merge.ics /var/www/wordpress/
chown www-data:www-data /var/www/wordpress/he-merge.ics
