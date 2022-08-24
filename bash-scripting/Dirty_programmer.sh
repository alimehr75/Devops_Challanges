#! /bin/bash
#Dirty programmer

echo "What is your name ?"
read NAME
echo "Dear $NAME what is your desired Tempretaure?"
read TEMPRATURE
if [ $TEMPRATURE -gt "40" ];then
  echo "So Hot Here"
else
  echo "Aren't you cold?"
fi
