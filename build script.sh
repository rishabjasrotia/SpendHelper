#!/bin/bash

INFILE=.env

DARTFILE="";
# Read the input file line by line
while read -r LINE
do
    DARTFILE+=" --dart-define=$LINE"
done < "$INFILE"
#printf '%s\n' "$DARTFILE"

eval "flutter build apk --release $DARTFILE"
