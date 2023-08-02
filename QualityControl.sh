#!/bin/bash

C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_NC='\033[0m' # No Color

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
  COUNT=$(grep -iEo "^[0-8A-Fa-f]{1}[0-9A-Fa-f]{7} [0-9A-Fa-f]{8}" "$a" | wc -l)
  MASTERCODE_COUNT=$(grep -iEo "^9[0-9A-Fa-f]{7} [0-9A-Fa-f]{8}" "$a" | wc -l)
#  printf "\r[$a]:"
  if [ -z "$HEAD" ]; then
    echo -e "${C_YELLOW} CHT/$a: could not find ELF ID on header${C_NC}"
    RETURN_CODE=1
  fi
  
  if [ NORMALIZE != 1 ]; then
    sed -Ei 's/[a-fA-F0-9]{8} [a-fA-F0-9]{8}/\L&/g' "$a"
  fi
  

  if [ "$HEAD.cht" != "$a" ]; then
    echo "${C_YELLOW} CHT/$a: has an invalid ELF header: [$HEAD]${C_NC}"
    RETURN_CODE=1
  fi

  if [ $COUNT -gt 250 ]; then
    echo -e "${C_YELLOW} CHT/$a: $COUNT Cheats detected, OPL Cheat engine supports up to 250 common cheats...${C_NC}" ;
    RETURN_CODE=1
  fi

  if [ $COUNT -le 0 ]; then
    echo -e "${C_RED} CHT/$a: $COUNT Cheats found!${C_NC}" ;
    RETURN_CODE=1
  fi

  if [ $MASTERCODE_COUNT -le 0 ] || [ $MASTERCODE_COUNT -gt 5 ]; then
    echo -e "${C_RED} CHT/$a: $MASTERCODE_COUNT Mastercodes. quantity out of range (1-5)...${C_NC}" ;
    RETURN_CODE=1
  fi

  if grep -q "Mastercode" "$a" ; then
    :
  else
    echo -e "${C_RED} CHT/$a: could not find a matching mastercode string${C_NC}" ;
    RETURN_CODE=1
  fi
done
#if at least one check failed, return nonzero so gh actions marks error on workflow summary
exit $RETURN_CODE
