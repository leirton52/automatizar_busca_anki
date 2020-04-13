#! /bin/bash

count=0

#anki &

while line
do
  if [ $count -ge 2 ]
  then
    continue
  fi

  count=$(( count+1 ))

  # google-chrome --new-window "https://www.google.com/search?tbm=isch&q=$line" "https://context.reverso.net/traducao/ingles-portugues/$line"
  echo "A palavra $count extá ok?"
  read ok;
  echo "$ok"

done < "${1:-/dev/stdin}"
