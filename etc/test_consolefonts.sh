#!/usr/bin/env bash

for file in /etc/static/kbd/consolefonts/*.gz; do
	setfont $file -14
	read -p "$file"
done
