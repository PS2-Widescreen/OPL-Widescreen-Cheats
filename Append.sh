#!/bin/bash

cd CHT
for a in *.cht
do
cat ../SUFFIX.txt >> $a
done
