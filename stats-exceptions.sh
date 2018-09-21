#!/usr/bin/env bash


cut -b100-400 | sed -e "
	s/\[[0-9a-f,]*\]//;
	s/[0-9]* --- \[[^\]]*\] //;
	s/300 --- \[ XNIO-1 task-58\] //;
	s/[0-9]* --- \[[ a-zA-Z0-9-]*\]//;
	s/REF\[[0-9A-F-]*\]//g;
	s/sys[^a-zA-Z0-9]*stripe.[0-9]*.[#0-9]*_[a-e0-9]*//g;
	s/concurrent.FutureTask@[0-9a-f]* rejected/FutureTask/g;
	s/concurrent.ThreadPoolExecutor@[0-9a-f]*\[[^\]]*/ThreadPoolExecutor/g;
	s/Failed processing message \[.*\]\]\\n/Failed processing message\\\\n/g;
	s/^[^A-Z]*//;
	s/Session 0x[0-9a-f]*/Session/g;
	s/\\\\n/ /g;s/\[null\] / /g;s/ *null *at */ /g;
	s/null *//g;s/null *at/at/g;
	s/senderId=[0-9a-f, -]*//g;
	s/updateSeq=[0-9a, ]*//g;
	s/, *pool *size *= *[0-9]*//g;
	s/Object of class .ch.migros.mdds.cmd.model.LastLogin. with identifier .[A-F0-9-]*./LastLogin/g;
	s/.id, [A-F0-9-]*, cache.//g;
	s/rejected value//;
	s/active threads = [0-9]*//;
	s/java.lang.//;
	s/java.util.//;
	s/Possible starvation in striped pool.*/Possible starvation in striped pool/;
	s/RetryExceptionLogger.*Person.*on.*field[^A-Za-z]*\([a-zA-Z]*\).*/RetryExceptionLogger : error on field \1/g;
	s/CODE//g;
	s/DETAIL//g;s/MESSAGE//g;
	s/[ :.][0-9][0-9]*/ /g;
	s/[^A-Za-z0-9 ]/ /g;
	" |\
	tr -- "-\t\$[]()<>;:,'\"" "       " | tr -s " " | cut -b1-100 | \
	sort | uniq -c |\
	sed -e "s/^[^0-9]*//" | sort -n

