#! /bin/bash
# ==========================BEGIN Welcomming =====================
echo "Welcome to Store!"
echo -n "What is your name ? "
read NAME
echo -e "Dear $NAME , This Is What I Have!\nDone For Quitting\n"
#===========================End Welcomming =======================

# ==============A Dictionary for goods and their price============
declare -A prices
prices["Pen"]="8000"
prices["Nbook"]="20000"
prices["Pencil"]="6000"
prices["Paper"]="90000"

#=============A Dictionary for goods have been bought=============
declare -A goods

#============Show what are there in the Store ===================
for key in "${!prices[@]}";do
	printf "%-10s%-6s\n" $key ${prices[$key]}
done
echo

#============Main ============
Total=0
Number=0
#this is for checking a number given of user is realy number or not
re='^[0-9]+$'

while true;
do
  echo -n "What Do You Want ? "
  read good
  #check if bought goods is empty or not

  if [ $good = "Done" -a "${#goods[@]}" != 0 ];then
    break

  elif [ -v prices[$good] ];then

    echo -n "How many $good Do You Want ? "
    read number

    if ! [[ $number =~ $re ]];then
      echo "you have to enter numbers"

    else
      good_price=$(($number * ${prices[$good]}))
      let Total+=good_price
      goods[$good]=$number,$(echo "price is $good_price")
      let Number+=number
    fi

  else
    if [ $good = "Done" ];then
      echo "Oh,No! You have to buy something!"
    else
      echo "I Havn't $good"
    fi

  fi
done


if [ $Total -gt 100000 ];then
  discount=0.05
  dis=$(echo "$Total*$discount" | bc)
  dis=${dis%.*}
  let Total-=dis
fi

echo -e "$(date +%Y/%m/%d-%H:%M) \n$NAME's Receipt" > /home/$USER/Store.log
echo -e "\n$NAME bought These :" >> /home/$USER/Store.log

for key in "${!goods[@]}";do
	echo -e "$key\t\t${goods[$key]}" >> /home/$USER/Store.log
done

echo -e "\nYou must pay $Total\$ for $Number goods" >> /home/$USER/Store.log

