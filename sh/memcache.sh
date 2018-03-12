#!/bin/sh
#A simple template of background shell.
#by Tony (tonylu@tony-cloud.com).
#Copyright 1992-2018 tony-cloud project.

#get pid of this shell#
pid=$$
#Type shell name into "".#
shname="memcache"
#searching for the same process's pid.#
pidrun=$(ps | grep $shname.sh | grep -v grep | grep -v $pid | awk '{print $1}')
#searching for the same process#
ps | grep $shname.sh | grep -v grep | grep -v $pid
if test $? -ne 0
then
	#if nothing, continue#
	#Type your code here.
	logger -t $shname": "$shname" start，begin monitor，PID" $pid
	while :
	do
		memchached=$(free |fgrep Mem |awk '{print $7 }')
		if test $memchached -gt 100000
		then
		    logger -t $shname ": too much cache, flush one. PID: " $pid
		    sync&&echo 1 > /proc/sys/vm/drop_caches
			sleep 10
		else
			sleep 20
			continue
		fi
	done
else
	#If something have been running, say goodbye.
	logger -t $shname": another "$shname" found. Multi startup detected, startup aborted. Another PID is " $pidrun
	logger -t $shname": Nothing to do, bye. PID "$pid
	exit 0
fi