#!/usr/bin/env python3

import sys

def process_line(line):
    line = line.strip()
    if not line:
        return "\\n"
    
    # Экранируем обратные слеши и кавычки
    line = line.replace('\\', '\\\\')
    line = line.replace('"', '\\"')
    
    return f'"{line} \\n"'

with open(sys.argv[1], "r") as file:
    lines = file.readlines()
    processed_lines = []
    for line in lines:
        processed = process_line(line)
        processed_lines.append(processed)
        
    for i in processed_lines:
        print(i)