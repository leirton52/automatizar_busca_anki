#!/bin/bash

echo "Searching for : $@"
for term in $@ ; do
    echo "$term"
    search="$search%20$term"
done
    google-chrome "https://www.google.com/search?tbm=isch&q=$search"
