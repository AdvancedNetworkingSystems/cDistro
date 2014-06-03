#!/bin/bash

pipe=/tmp/cDistroEP
pid=$$

trap rm_pipe EXIT
trap end_program KILL HUP INT TERM EXIT
trap restart USR1


function restart {
	echo "kill my pid: $pid"
}

function end_program {
	echo "End program"
	rm -f $pipe	
	exit
}


if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

while true
do
	while read line 
	do 
		cmd="$line &> /dev/null &"
		echo Execute:$cmd
#	    nohup $cmd &> /dev/null &
	    eval $cmd
	done < $pipe
done

echo "End"