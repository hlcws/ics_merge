#!/bin/sh
wget -O ranbat-raw.ics https://forum.hardedge.org/calendar/index.php?calendar-export/6/
wget -O turnier-raw.ics https://forum.hardedge.org/calendar/index.php?calendar-export/7/

awk '/END:VEVENT/{print"CATEGORIES: Turnier"}1' turnier-raw.ics > turnier-categories.ics
awk '/END:VEVENT/{print"CATEGORIES: Ranbat"}1' ranbat-raw.ics > ranbat-categories.ics

echo "BEGIN:VCALENDAR
PRODID:-//merge//example.com//
VERSION:2.0
X-WR-CALNAME:example.com" > he-merge.ics

awk '/BEGIN:VEVENT/,/END:VEVENT/' turnier-categories.ics >> he-merge.ics
awk '/BEGIN:VEVENT/,/END:VEVENT/' ranbat-categories.ics >> he-merge.ics

echo "END:VCALENDAR" >> he-merge.ics