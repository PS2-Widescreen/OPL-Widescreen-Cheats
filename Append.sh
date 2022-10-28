#!/bin/bash

cd CHT
for a in *.cht
do
  cat ../SUFFIX.txt >> $a
  if [ -z "$1" ]
    then
      echo "$1" >> $a
  fi
done
