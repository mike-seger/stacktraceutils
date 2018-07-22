#!/usr/bin/env bash

logtspattern="20[1234][0-9][^0-9]"

if [ $# = 0 ] ; then
	echo "Usage: $0 <log-files|log-archives.tgz>"
	echo "-> outputs the number of occurred exceptions of a specific type per line sorted by occurrence"
	exit 1
fi

function parseStackTracesFromText() {
	grep -v "^[[:space:]]*$" |\
	sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" |\
	sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | sed "s/\x0f//g" |\
	sed -e "
		y/\\\\%/__/;
		s/^\($logtspattern\)/\\\\\1/" |\
	tr '\n\t\\' "% \n" |\
	sed -r -e "s/%[[:space:]]+at/%\\tat/" |\
	grep -P "%\tat" |\
	sed -e 's/%/\\n/g;'
#cut -b1-500 ;	return
#	echo  |\
}

function pstTgz() {
	if [[ "$1" =~ .*tgz || "$1" =~ .*tar.gz ]] ; then
		tar --to-stdout -xf "$1" | parseStackTracesFromText
	elif [[ "$1" =~ .*\.gz ]] ; then
		gunzip -c "$1" | parseStackTracesFromText
	else
		cat "$1" | parseStackTracesFromText
	fi
}

for f in "$@" ; do
	pstTgz "$f"
done #| sort -r

# filter by date ranges, sort and count groups
# | grep "^2017-0[56]" | egrep -v "^(2017-05-[01]|2017-06-0[7-9])" | cut -f2 | cut -b1-300 | sort | uniq -c | sort -rn
# | grep "^2017-06-0[7-9]" | cut -f2 | cut -b1-300 | sort | uniq -c | sort -rn

# Format stack traces again
# | sed -r -e "s/\\\\n[[:space:]]/\n\t/g" |cut -b1-80
# 

# extract latest stack traces 
# cat qcmd-appsrv-2017-05+06-top-exceptions.txt | sed -e "s/^ *//;s/ at /\&/;s/^ *\([0-9]\)* at /\1\t/;s/\\\\n/./g;y/ \t():-/....../;s/[.][.]*/.*/g;s/&/\t/" | while read f ; do f1=$(printf "%s\n" "$f"|cut -f1); f2=$(printf "%s\n" "$f"|cut -f2); printf "%s\t" "$f1" ; grep -m1 "$f2" qcmd-appsrv-2017-05+06-exceptions-framed-rev.txt ; break ; done
# cat qcmd-appsrv-2017-05+06-top-exceptions.txt | sed -e "s/^ *//;s/ at /\&/;s/^ *\([0-9]\)* at /\1\t/;s/\\\\n/./g;y/[] \t():-/......../;s/[.][.]*/.*/g;s/&/\t/" | while read f ; do f1=$(printf "%s\n" "$f"|cut -f1); f2=$(printf "%s\n" "$f"|cut -f2); printf "%s\t" "$f1" ; grep -m1 "$f2" qcmd-appsrv-2017-05+06-exceptions-framed-rev.txt ; done >qcmd-appsrv-2017-05+06-top-exceptions-full.txt

