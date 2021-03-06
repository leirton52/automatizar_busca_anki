#! /bin/bash

#starting the timer
timer_init=$(date +"%s")

count=0
number_of_word=2

#searching if the wmctrl(windows manager control) is installed and installing it if not
if [ $(which wmctrl) ]
  then
	echo "wctrl está instalado" > .log
  else
    echo "O wmctrl(gerenciador de controle de janelas) será instalado"
    echo ""
    sudo apt install wmctrl
    echo ""
    echo "wmctrl instalado com sucesso"
    echo "wmctrl instalado com sucesso" > .log
fi

declare -a search_word
declare -a rest_word

#cleaning import file
if [ -f cards_to_import ]
then
    rm cards_to_import
fi

anki >& message_anki.txt &

#Separating the words that will be search 
 while IFS= read -r line
 do
  if [ $count -lt $number_of_word ]
  then
    search_word[$count]=$line
  else
    rest_word[$(( $count - $number_of_word ))]=$line
  fi
    count=$(( count+1 ))
done < "para_pesquisar"

#searching for words and inserting them in the your file.
count=1 # This counter shows us which word are searching for(position)
echo -e "\n$(date +"%d/%m/%y")\n" >> pesquisadas #search header of the day
for word in "${search_word[@]}"
do
  google-chrome --new-window "https://www.google.com/search?tbm=isch&q=$word" "https://context.reverso.net/traducao/ingles-portugues/$word" >& message_google.txt
  
  #creating the file with the cards to import
  echo -e "\e[1;32m$count   ----   $word   ----\e[0m"
  echo -e "\e[1;34mInsira a frase da frente do cartão:\e[0;33m "
  read front; #card's front
  echo -e "\e[1;34mInsira a frase de trás do cartão:\e[0;33m "
  read back; #card's back
  front=${front//$word/<b>$word</b>} #changing the searched world to bold
  echo "$front § $back" >> cards_to_import # stored the phrases
  echo -e -n "\e[1;34m$count - a palavra --$word-- foi inserida no anki? \e[1;33m"
  read ok;

  echo "$word - $ok" >> "pesquisadas" #stored the searched words in the control file
  count=$(( $count + 1 ))
  echo ""

  #closing the window that was opened
  wmctrl -c "$word"
done

#salving the file with the words not searched
> para_pesquisar
for word in "${rest_word[@]}"
do
  echo "$word" >> "para_pesquisar"
done

#ending the timer
timer_end=$(date +"%s")

time_min=$(echo "scale=2; ($timer_end - $timer_init)/60" | bc)
echo -e "Foram gastos --$time_min minutos-- hoje" >> pesquisadas
echo -e "Foram gastos --\e[1;31m$time_min minutos\e[1;33m-- hoje"
