#! /bin/bash

count=0
number_of_word=5

declare -a search_word
declare -a rest_word

  #anki &
  # google-chrome --new-window "https://www.google.com/search?tbm=isch&q=$line" "https://context.reverso.net/traducao/ingles-portugues/$line"

#Separating the words that will be search 
 while read line
 do
  if [ $count -lt $number_of_word ]
  then
    search_word[$count]=$line
  else
    rest_word[$(( $count - $number_of_word ))]=$line
  fi
    count=$(( count+1 ))
done < "${1:-/dev/stdin}"


echo >> pesquisadas
echo "$(date +"%d/%m/%y")" >> pesquisadas
echo >> pesquisadas
for word in ${search_word[*]}
do
  echo "$word - OK" >> "pesquisadas"
done


> para_pesquisar
for word in ${rest_word[*]}
do
  echo "$word" >> "para_pesquisar"
done

