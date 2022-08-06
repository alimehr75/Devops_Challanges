#! /bin/bash
# ==========================BEGIN Welcomming =====================
echo -ne "Welcome to Store!\nWhat is your name ? "
read NAME;sleep 1
echo -e "Okay Dear $NAME , Here is List Of Options\n"
#===========================End Welcomming =======================

# ==============A Dictionary for goods and their price============
declare -A prices
prices["Pen"]="8000"
prices["NoteBook"]="20000"
prices["Pencil"]="6000"
prices["Paper"]="90000"
prices["Done"]="Done is To Finish Choosing!"

#============Show what are there in the Store ====================

function menu {
  for key in "${!prices[@]}";
  do
    printf "%-10s ==> %s\n" $key "${prices[$key]}"
done

echo -e "\n"
}

# ==========Here a function add items to goods list==============

declare -A goods

Total_price=0
Totla_number=0

function ask {
  echo -n "How Manay Do You Need ? "
  read number
  good_price=$(($number * ${prices[$1]}))
  goods[$1]=$(echo -e "$number $1  \tPrice is $good_price")
  let Total_number+=number
  let Total_price+=good_price
}

# This function is for chceking price

function price {
  if [ $Total_price -ge 100000 ];then
    discount=$(echo "$Total_price * 0.05"|bc -l)
    Total_price=$(echo "$Total_price - $discount" | bc -l)
    printf "\nYour total Price for %d goods with 5%% discount is: %.0f $\n"  $Total_number $Total_price
  else
    printf "\nYour total Price for %d goods is: %.0f $\n"  $Total_number $Total_price
  fi
}

# a function to check list is empty or not!

function check {
  if [ ${#goods[@]} == 0 ];then
    echo "You've Chosen Nothing!"
    return $(false)
  else
    return $(true)
  fi
  
}

# a function to show chosen stuffs

function show_list {
  if check;then
    echo -e "$NAME's Receipt : "
    for key in "${!goods[@]}";
    do
      echo "-----------------------------------------------"
      printf "${goods[$key]}\n"
    done
  fi
}

# main function 
function main1 {
  menu;sleep 1
  select item1 in "${!prices[@]}"
  do
    case $item1 in
      "Paper")
        ask "Paper"
        ;;
      "NoteBook")
        ask "NoteBook"
        ;;
      "Pen")
        ask "Pen"
        ;;
      "Pencil")
        ask "Pencil"
        ;;
      "Done")
        if check;then
          break
        fi
        ;;
      *)
        echo "No No! You Have To Choose One Of The Above! You chose $REPLY"
    esac
  done
}

# This function is for operators
function main2 {

  operator_menu=("Show" "Help" "Quit")

  function operators {
    echo """
            Show ==> Show what have you chosen far now!
            Help ==> Show This Help Menu!
            Quit ==> Quit from store
            Buy  ==> You can Choose again

    """

    }
    select item2 in "${operator_menu[@]}"
    do
      case $item2 in
        "Show")
          show_list
          ;;
        "Help")
          operators
          ;;
        "Quit")
          echo "Hav a Nica Day,dude!"
          break
          ;;
        *)
          echo "No No! You Have To Choose One Of The Above! You chose $REPLY"
      esac
    done

}


main1
main2
result1="$(show_list)"
result2="$(price)"
# >> /home/$USER/Receipt.log
echo -e """
$(date +"%A %d %b %Y At %r")\n
$result1
$result2\n
Have A Nice Day!
GoodBy!
""" > /home/$USER/Receipt.log
#price >> /home/$USER/Receipt.log

