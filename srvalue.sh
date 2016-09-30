#!/usr/bin/env bash

red='\033[0;31m'			# Red
nc='\033[0m'				# No color
re='^[0-9]+$'				# Regular expression to detect natural numbers

usage() { echo -e "Usage: $0 -i <filename> -s <seed>\n-i\tInput filename\n-s\tSeed" 1>&2; exit 1; }


while getopts ":i:s:" o; do
	case "${o}" in
	i)
		i=${OPTARG}
		if [ ! -f "$i" ]
		then
			echo -e "${red}Input file \"$i\" not found!${nc}\n"
			usage
		fi
		;;
	s)
		s=${OPTARG}
		if ! [[ $s =~ $re ]] ; then
			echo -e "${red}Seed must be a number!${nc}\n"
			usage
		fi
		;;
	\?)
		echo -e "${red}-$OPTARG is not a valid option!${nc}\n"
		usage
		;;
	esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${s}" ]
then
	echo -e "${red}Missing one or more required options!${nc}\n"
	usage
fi

N=`sed '1q;d' $i`	# Number of agents
K=`sed '2q;d' $i`	# Maximum cardinality

tmp=`mktemp`
echo "#define N $N" > $tmp
echo "#define K $K" >> $tmp
echo "#define INPUTFILE \"$i\"" >> $tmp

if [ ! -f instance.h ]
then
	mv $tmp "instance.h"
else
	md5a=`md5sum instance.h | cut -d\  -f 1`
	md5b=`md5sum $tmp | cut -d\  -f 1`

	if [ $md5a != $md5b ]
	then
		mv $tmp "instance.h"
	else
		rm $tmp
	fi
fi

make -j
if [[ $? == 0 ]]
then
	bin=$0
	bin=${bin%???}
	$bin $s
fi