#!/bin/bash

FOLDER="/путь/к/вашей/папке" # Замените на ваш путь 
SERVER="http://ваш.сервер.адрес" # Замените на адрес сервера

if [ ! -d "$FOLDER" ]; then 
    exit 1
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
    
    curl -X POST "$SERVER" -d "$data" --silent
    
done
