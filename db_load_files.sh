#!/usr/bin/bash
if [ $# -eq 1 ] 
then dir="$1"
    echo Changing dir to "$1"
    saved_dir=`pwd`
else dir=json
fi
cd "$dir"

files=*.json

for f in $files;
    do coll="${f%.json}"
    echo loading "$f" into collection "$coll"
    mongoimport -d airbnb --collection="$coll" --jsonArray mongodb://localhost:27017/ "$f"
done
if [[ -v saved_dir ]]; then cd "$saved_dir"; fi
