# get data for linie 10, richtung 1

awk -F, '{if($1==10&&$2==1)print$0}' *.csv > ../linie10richtung1