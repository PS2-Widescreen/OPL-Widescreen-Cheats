#!/bin/bash
RETURN_CODE=0
cd CHT
for a in *.cht
do
  HEAD=""
  HEAD=$(head -n1 -q "$a" | grep -Eo [0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]_[0-9][0-9][0-9].[0-9][0-9])
  if [ -z "$HEAD" ]; then
    echo "[$a]: could not find ELF ID on header"
    RETURN_CODE=1
  fi

  if [ "$HEAD.cht" != "$a" ]; then
    echo "[$a]: has an invalid ELF header: [$HEAD]"
    RETURN_CODE=1
  fi
  
  if  grep -qE "Mastercode\n9[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z] [0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]" "$a" ; then
    :
  else
    echo "[$a]: could not find a matching mastercode" ;
    RETURN_CODE=1
  fi
done
#if at least one check failed, return nonzero so gh actions marks error on workflow summary
exit $RETURN_CODE
