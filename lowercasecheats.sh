#!/bin/bash

cd CHT/
for a in *.cht; do sed -Ei 's/[a-fA-F0-9]{8} [a-fA-F0-9]{8}/\L&/g' "$a"; done
