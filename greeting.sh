#!/bin/bash

RETURN_CODE=0

if [ -f "$1" ]
then
echo "### Hello! this is an automated message designed to help the repository maintainers"
echo "### __Please make sure your report is clearly readable and that you provided all the needed information!__"

if [ -f "LINKLIST.TXT" ]; then rm LINKLIST.TXT; fi

    for a in $(grep -Eo '[a-zA-Z]{4}_[0-9]{3}.[0-9]{2}' "$1")
    do
        if [ -f "CHT/$a.cht" ]
        then
            echo " - [\`$a.cht\`](https://github.com/PS2-Widescreen/OPL-Widescreen-Cheats/blob/main/CHT/$a.cht)" >> LINKLIST.TXT
        else
            echo "'CHT/$a.cht' does not exist"
        fi
    done

    if [ -f "LINKLIST.TXT" ]
    then
        echo "Seems like you mentioned at least one game ID wich exists in this repository! i'll link them here:"
        sort "LINKLIST.TXT" | uniq
    fi
else
    RETURN_CODE=1
    echo "ERROR: expected argumment one to be a path to a file containing the issue report to analize" 
fi
exit $RETURN_CODE