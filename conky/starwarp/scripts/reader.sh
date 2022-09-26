#!/usr/bin/env sh

# ###################################################
# Script:       reader.sh                           #
# Version:      0.30                                #
# Author:       Adeel Ahmad (adeelahmadk)           #
# Date Crated:  Mar 23, 2020                        #
# Date Updated: Apr 14, 2020                        #
# Usage:        reader uri | FILE                   #
# Description:  Feed reader script to extract,      #
#               transform and store feeds from      #
#               given uri or file of uri's.         #
# ###################################################

# Executables with absolute paths
_CURL=`which curl`
_AWK=`which awk`
_GREP=`which grep`
_SED=`which sed`
_CUT=`which cut`
_RM=`which rm`
_MKDIR=`which mkdir`

_FILTER="$HOME/.config/conky/starwarp/scripts/filter.sh"

# Global Vars
_DEFAULT_STORE="$HOME/.cache/conky"
STORAGE=""
#CACHEFILE="feedcache.xml"
OUTFILE=""
SELECTOR=""
REQ_HEAD_ACCEPT="accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
REQ_HEAD_LANG="accept-language: en-US,en;q=0.4"
REQ_HEAD_AGENT="user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Falkon/3.1.0 Chrome/69.0.3497.128 Safari/537.36"
CURL_STATUS=""

# Components of URI link
PROTO=''
URL=''
NETLOC=''
HOST=''
SUBPATH=''
FQDN=''

print_usage() {
  echo "Usage: `basename $0` uri | FILE" 1>&2
  echo "       Output is saved in a file named <domain.feed>" 1>&2
  echo " uri   URI to fetch feed" 1>&2
  echo " FILE   File with more than one uri to fetch feed" 1>&2
}

clean_default_store() {
  feedpath="$_DEFAULT_STORE/*.feed"

  for file in $feedpath
  do
    if [ -f "$file" ]; then
      $_RM "${file}"
    fi
  done

  return "$?"
}

get_http_headers() {
     CURL_STATUS=$("$_CURL" -o /dev/null --max-time 10 --silent -I -H "$REQ_HEAD_ACCEPT" -H "$REQ_HEAD_LANG" -H "$REQ_HEAD_AGENT" --write-out "%{http_code} %{content_type}" "$1")
}

is_valid_uri() {
  if [ -z "$CURL_STATUS" ]; then
    get_http_headers "$1"
  fi

  local result="$(echo ${CURL_STATUS} | $_AWK '{print $1;}')"
  if [ "$result" -eq 200 ]
  then
    #Comparison successfull with $status
    return 0
  else
    #Comparison failed with $status
    return 1
  fi
}

is_valid_rss() {
  if [ -z "$CURL_STATUS" ]; then
    get_http_headers "$1"
  fi

  local result="$(echo ${CURL_STATUS} | $_GREP -E 'rss|xml')"
  if [ -n "$result" ]; then
    return 0
  else
    return 1
  fi
}

parse_link() {
  URL="$1"
  # Extract protocol
  PROTO="$(echo $URL | $_GREP :// | $_SED -e's,^\(.*://\).*,\1,g')"
  # Remove protocol from the url
  URL="$(echo $URL | $_SED -e s,$PROTO,,g)"
  # Extract username & password
  USERPASS="$(echo $URL | $_GREP @ | $_CUT -d@ -f1)"
  # Extract the host
  NETLOC="$(echo $URL | $_SED -e s,$USERPASS@,,g | $_CUT -d/ -f1)"
  PORT="$(echo $NETLOC | $_GREP : | $_SED -e 's,.*:\([0-9]*\).*,\1,g')"
  HOST="$(echo $NETLOC | $_SED -e s,:$PORT,,g)" #"($_AWK -F. '{print $(NF-1);}')"
  SUBPATH="$(echo $URL | $_CUT -d/ -f2-)"
  FQDN="$(echo $HOST | $_SED 's,\([^ @]*\)\.[^ @]*$,\1,g' | $_AWK -F. '{print $NF;}')"
}

fetch_feed() {
   # Save feed link to a variable
  LINK="$1"

  if ! is_valid_rss $LINK; then
    echo "$LINK: Not a valid RSS feed!"
    exit 2
  fi

  parse_link $LINK

  SEP='\n\n'
  SELECTOR='item > title'
  OUTFILE="$STORAGE/$FQDN"

  category=
  if [ -n "$SUBPATH" ]; then
    category="$(echo $SUBPATH | $_AWK -F/ '{print $NF;}' | $_SED 's/[ _]/-/g')"
    if [ -n "$category" ]; then
      OUTFILE="$OUTFILE.$category"
    fi
  fi

  OUTFILE="$OUTFILE.feed"
  local CACHEFILE="$STORAGE/feedcache.xml"

  $_CURL -s -H "$REQ_HEAD_ACCEPT" -H "$REQ_HEAD_LANG" -H "$REQ_HEAD_AGENT" $LINK > $CACHEFILE
  title="$(cat $CACHEFILE | hxselect -c 'channel > title' | hxuncdata | hxunent)"

  #echo "Fetching feed from '${title}'..."
  echo "$title" > $OUTFILE
  echo "" >> $OUTFILE

  cat $CACHEFILE | hxnormalize -x | hxselect -c -s $SEP $SELECTOR | hxuncdata | hxunent | $_FILTER >> $OUTFILE

  if [ "$?" -ne 0 ]; then
    echo "Failed to fetch feed from $HOST" 1>&2
  fi

  rm $CACHEFILE
}

if [ "$#" -eq 0 ]; then
    print_usage
    return 1
elif [ "$#" -eq 1 ]; then
    if [ ! -d "$_DEFAULT_STORE" ]; then
        $_MKDIR -p "$_DEFAULT_STORE"
        if [ "$?" -gt 0 ]; then
            echo "Require read and write permission on ${_DEFAULT_STORE}" 1>&2
            return 4
        fi
    fi

    STORAGE="$_DEFAULT_STORE"

    if is_valid_uri "$1"; then
        CURL_STATUS=""
        clean_default_store
        fetch_feed "$1"
    elif [ -r "$1" ]; then
        clean_default_store
        while IFS= read line
        do
            CURL_STATUS=""
            if [ -n "$line" ] && is_valid_uri "$line"; then
                #echo "Starting to fetch: ${line}..."
                fetch_feed "$line"
                #if [ -n "$OUTFILE" ]; then
                #    echo "Feed saved to '${OUTFILE}'..."
                #fi
            fi
        done < $1
    else
        echo "$1 not a valid URI or file name!" 1>&2
        echo
        print_usage
        return 1
    fi
fi

