#!/bin/bash

RETURN_CODE=0
cd CHT
for a in *.cht
do
  COUNT=$(grep -iEo "^[0-9A-Fa-f]{8} [0-9A-Fa-f]{8}" $a | wc -l)
  if [ $COUNT \> 255 ]; then
    :
  else
    echo "[$a]: $COUNT Cheats detected, while OPL Cheat engine only supports a total of 255 cheats..." ;
    RETURN_CODE=1
  fi
done
#if at least one check failed, return nonzero so gh actions marks error on workflow summary
exit $RETURN_CODE

