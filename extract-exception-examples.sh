#!/bin/bash

exceptions=$1

file=$1
if [ "$1" == '-' ] ; then
	file=		
elif [ ! -f "$1" ] ; then
	echo "Usage: $0 <exceptions-file|>"
	echo "Use - for stdin"
	exit 0	
fi

mkdir -p out

cat $file | $(dirname $0)/stats-exceptions.sh | sed -e "s/ /\\t/" | while read line ; do
	pat=$(echo "$line" | sed -e "s/.*\\t//;s/ /.*/g")
	n=$(grep -c "$pat" "$exceptions")
	m=$(echo "$line" | sed -e "s/\\t.*//")
#	if [[ "$((n+m))" -lt 20 || "$m" -lt 10  || "$n" -lt 10 || "$n" -gt "$((m*5))" ]] ; then
#		continue
#	fi	
	file=$(printf "%05d\t%s\n" "$n" "$line"| \
		cut -b1-60|cut -f1,3|tr "\t" " "|sed -E "s/ *$//;s/ [a-zA-Z]{0,3}$//;").txt
	grep "$pat" "$exceptions" | sort -u | tail -1 |sed -E "s/\\\\n/\\n/g">out/"$file"
done
echo "Created exception examples in directory 'out'"
