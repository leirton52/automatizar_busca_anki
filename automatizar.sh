#! /bin/bash

count=0
number_of_word=2

declare -a search_word
declare -a rest_word

anki >& message_anki.txt &

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

#the searched words in the your file. 
echo >> pesquisadas
echo "$(date +"%d/%m/%y")" >> pesquisadas
echo >> pesquisadas

for word in ${search_word[*]}
do
  google-chrome --new-window "https://www.google.com/search?tbm=isch&q=$word" "https://context.reverso.net/traducao/ingles-portugues/$word" >& message_google.txt

  echo "a palavra --$word-- foi inserida no anki?"
  read ok;
  echo "$word - $ok" >> "pesquisadas"
done

#salving the file with the words not searched
> para_pesquisar
for word in ${rest_word[*]}
do
  echo "$word" >> "para_pesquisar"
done
