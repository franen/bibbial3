#!/bin/sh
#inizio prendendo il file bibbia.db generato con il servizio di Eleutheros.org 
#+e faccio le sostituzioni per renderlo compatibile con LaTeX.
sed -f sostLaTeX3.sed bibbia.db > bibbiasost.tex
sed -f verslettere.sed bibbiasost.tex > bibbiasost2.tex
#spezzo il file perché altrimenti poi lo script non gestisce tutti i capitoli della Bibbia assieme (sulla mia macchina virtuale, su altri PC lavora anche senza apezzare i file)
csplit -f BIBBIA bibbiasost2.tex '/Gl£1£/'
#creo la cartella in cui inserire i capitoli (e se esiste già Linux non si lamenta)
mkdir -p capitoliLaTeX3
cd capitoliLaTeX3
#svuoto la cartella, se c'è dentro qualcosa
for i in $(ls);
do
rm $i
done
#divido la prima parte della bibbia nei singoli capitoli e aggiungo l'estensione.tex 
awk -F£ "{ print \$3 >>\$1\$2\".tex\"}" ../BIBBIA00
#faccio la stessa cosa con la seconda parte
awk -F£ "{ print \$3 >>\$1\$2\".tex\"}" ../BIBBIA01
#aggiungo \endinput alle fine del file
for cap in $(ls); 
do
 echo "\endinput" >> "$cap"
done
#elimino i file spezzati e quello temporaneo
cd ..
rm -f BIBBIA00
rm -f BIBBIA01
rm -f bibbiasost.tex
rm -f bibbiasost2.tex
exit
