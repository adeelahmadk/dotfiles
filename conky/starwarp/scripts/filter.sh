#!/usr/bin/env sh

# ###################################################
# Script:       filter.sh                           #
# Version:      0.20                                #
# Author:       Adeel Ahmad (codegenki)             #
# Date Crated:  Mar 23, 2020                        #
# Date Updated: Apr 14, 2020                        #
# Usage:        filter FILE                         #
# Description:  Filter script for feed reader's     #
#               FTL pipeline to scrub and transform #
#               (single lined) scraped feed data.   #
# ###################################################

BUF=
#COUNT=0
FEEDNO=1

process() {
    local line="$1"
    local SED=`which sed`
    if [ -n "$line" ]; then
        line=`echo $line | $SED 's/ *$//g'`
        BUF="$BUF$line "
    elif [ -n "$BUF" ]; then
        #COUNT=$((COUNT+1))
        #if [ $((COUNT%2)) -ne 0 ]; then #Even num lines to include description
        echo "$FEEDNO. $BUF"
        FEEDNO=$((FEEDNO+1))
        #else
            #echo "$BUF"
        echo
        #fi
        BUF=
    fi
}

print_usage() {
	echo "Usage: `basename $0` FILE"
    echo "       With no FILE, reads stdin"
}

# Check to see if a pipe exists on stdin.
if [ -p /dev/stdin ]; then
        # If we want to read the input line by line
        while IFS= read line; do
                process "${line}"
        done
        # Or if we want to simply grab all the data, we can simply use cat instead
        # var="$(cat)"
else
        # Checking to ensure a filename was specified and that it exists
        if [ "$#" -gt 0 ] && [ -f "$1" ]; then
                #echo "Filename specified: ${1}"
                #echo
                INFILE="$1"
                #Doing things now...
                while IFS= read line
                do
                    process "${line}"
                done < $INFILE
        else
                echo "No input provided!"
                print_usage
                return 1
        fi
fi

