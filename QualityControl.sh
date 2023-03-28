#!/bin/bash


for i in $@
do 
  if [ "$i" = "--help" ]; then
	echo "available switches:"
	echo "--no-case-normalize : dont normalize case of cheat codes"
	exit
  fi

  if [ "$i" = "--no-case-normalize" ]; then
	echo " -- cheat codes case will NOT be normalized"
	NORMALIZE = 1
  fi
done

RETURN_CODE=0
LOL=0
cd CHT
for a in *.cht
do
  HEAD=""
  HEAD=$(head -n1 -q "$a" | grep -Eo [0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]_[0-9][0-9][0-9].[0-9][0-9])
  COUNT=$(grep -iEo "^[0-9A-Fa-f]{8} [0-9A-Fa-f]{8}" "$a" | wc -l)
  printf "\r[$a]:"
  if [ -z "$HEAD" ]; then
    echo " could not find ELF ID on header"
    RETURN_CODE=1
  fi
  
  if [ NORMALIZE != 1 ]; then
    sed -Ei 's/[a-fA-F0-9]{8} [a-fA-F0-9]{8}/\L&/g' "$a"
  fi
  

  if [ "$HEAD.cht" != "$a" ]; then
    echo " has an invalid ELF header: [$HEAD]"
    RETURN_CODE=1
  fi

  if [ $COUNT -gt 255 ]; then
    echo " $COUNT Cheats detected, while OPL Cheat engine only supports a total of 255 cheats..." ;
    RETURN_CODE=1
  fi

  if  grep -q "Mastercode" "$a" ; then
    :
  else
    echo " could not find a matching mastercode string" ;
    RETURN_CODE=1
  fi
done
#if at least one check failed, return nonzero so gh actions marks error on workflow summary
exit $RETURN_CODE
