!/bin/bash
###################################################################################################################################################################################
# Funktion Suchen des Preises                                                                                                                                                     #
###################################################################################################################################################################################

function anzeige () {
#  String auf den Preisblock begrenzen
   preis=$1
   preis=${preis%% &euro*}                                      # Wenn Sorte nicht gefunden, dann ist die Variable preis jetzt leer
   preis=${preis##*\<td\>}                                      # Alles vor dem Anfang des aktuelle Preisblock löschen
   preis=`echo $preis | tr "," "."`                             # Komma durch Punkt ersetzen

}

###################################################################################################################################################################################
# Programm-Aufruf      V1 (11.06.2015	)                                                                                                                                         #
###################################################################################################################################################################################

# Deklaration der Variabeln
  URL="http://www.sparsamtanken.de/tankstellen-details?tankstelle="$1
  merker="spritpreise"
  logfile="/var/log/sparpreise_"$1".log"
  tstfile=$(dirname $0)"/StarTest.log"
  errfile=$(dirname $0)"/Error$(date +"_"%Y"-"%m"-"%d"_"%H"-"%M).html"
 #logfile="/dev/stdout"; tstfile="/dev/stdout";
  
# URL aufrufen und Zeile mit den Preisen einer Variablen zuweisen
  preise=$(wget -q -O - $URL | grep -i -C 30 $merker)
 #preise=$(cat $(dirname $0)/${1##*/} | grep -m 1 $merker)

# Nur für Debugging: Bei fehlendem Preis Seite speichern
 #if [ $(echo $preise | grep -c '>z.Zt. nicht verf') -ne 0 ]; then wget -q -O $errfile $URL; fi

# Die Preis für die drei Sorten ermitteln, dazu den Blockbeginn suchen, Anzeige auswerten und Ergebnis der Sorte zuweisen
  preis=$( echo $preise | grep '>Super E5<')
  anzeige "${preis##*\>Super E5\<}"         ;  sup=$preis
  preis=$( echo $preise | grep '>Super E10<')
  anzeige "${preis##*\>Super E10\<}";  e10=$preis
  preis=$( echo $preise | grep '>Diesel<')
  anzeige "${preis##*\>Diesel\<}"        ;  die=$preis

# Ausgabedatei für Munin schreiben
  echo sup.value $sup  >$logfile
  echo e10.value $e10 >>$logfile
  echo die.value $die >>$logfile 

# Test-Logfile
 #echo $(date)$'\t'Die: $die$'\t'E10: $e10$'\t'Sup: $sup$'\t'$preise >> $tstfile
  exit
