/BEGIN:VEVENT/ {p=1};{if (p==1) {a[NR]=$0}};
/DTSTART:2019/ {f=1};
/END:VEVENT/ {p=0;
if (f==1) {for (i in a) print a[i]};f=0; delete a}
