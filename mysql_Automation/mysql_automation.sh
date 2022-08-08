#! /bin/bash

## ########## This automation is for Ubuntu distro ############

echo -e "Here we are going to install A database! \n\
At first we have to check if your Repositories are updated or not! \n"

# ========================= BEGINING of Functions Section ==========================

# a function to interact with user to give an answer 

function agree {
	echo -ne "Do you Agree ? [y/n] "
	read answer
	# convert all answers  to lower string
	answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

	if [ $answer == "n" -o $answer == "no" ];then
		echo "Bye!"
		exit 1

	elif [ $answer == "y" -o $answer == "yes" ];then
		return $(true)

	else
		echo "Bye!"
		exit 1

	fi

	sleep 3
}

# a function to install databse

function installit {
	sudo apt-get install $1
	echo -e "\n============ Done! $Userdb installed Successfully  ===============\n"
	sleep 3
}

# ========================= END of Functions Section ==========================

echo "First your repositories have to be updated " 
sleep 2
sudo apt-get update
echo -e "\n========================= All Repository Updated ======================\n";sleep 2
sudo apt-get upgrade
echo -e "\n==========================All Repository Upgraded =====================\n";sleep 2

# a list of Databases

echo "Which database do you want to install ? "
databases=("mysql-server-8.0" "mariadb-server-10.6 ")

# Options to user select it 

select item in ${databases[@]}
do
	case $item in 
		"mysql-server-8.0")
			installit mysql-server-8.0
			break
			;;
		"mariadb-server-10.6")
			installit mariadb-server-10.6
			break
			;;
		*)
			echo "You have to choose on of the above $REPLY"
			;;
	esac
done

# move default configs to users home prevent of future mistakes

echo "to prevent future mistakes in config , default config file will copy to /home/$USER"

if agree;then
	sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /home/$USERi/mysqld.cnf
  echo "Done! default configs moved to /home/$USER/mysqld.cnf" 
fi
sleep 2

# here is Explanation what configs are gonna change ! 
echo """
1. Changing default ip port 3306 to port 13306
2. Commenting bind_address to allow a user can connect to mysql with other ip addresses  
3. Set new port to accept inputs in port (13306) with iptables
"""
 
# Here changin default port 3306  --> 13306.

echo -e "Mysql default port is changing to 13306\n" 
sleep 3
if agree;then
	sudo sed -i.default '/^#port.*3306$/a port  =  13306' /etc/mysql/mysql.conf.d/mysqld.cnf
fi

# here  bind address will be commited.
# for connecting remotly.

echo -e "\ncommenting bind_address\n" 
if agree;then
	sudo sed -e '/bind_address/ s/^#*/#/' -i.default /etc/mysql/mysql.conf.d/mysqld.cnf
	echo "bind_adrees line commented in config file\n"
fi

# here changeing the mysql engin to innodb.
# and set its buffersize to 256MB.
echo -e "changing mysql engin to innodb and set its buffer size to 256 MB\n"
if agree;then
	sudo sed -i.default '/^[mysqld]/a default-storage-engine = innodb' /etc/mysql/mysql.conf.d/mysqld.cnf
  sudo sed -i.default '/^default.*innodb$/a innodb_buffer_pool_size = 256M' /etc/mysql/mysql.conf.d/mysqld.cnf
fi
# Here sthe mysql service has to restart
echo "mysql service restarting due to config has been changed "

sudo systemctl restart mysql.service

# Here changing iptables to accept and drop IPs to port 13306.

echo -e "Setting port 13306 with iptables" 
sleep 3
if agree;then
	echo -n "what is your ip adreess : "
	read userip
	serverip=$(hostname -I | cut -d" " -f1)
	sudo iptables -A INPUT -p tcp -s $userip -d $serverip  --destination-port 13306 -j ACCEPT
	sudo iptables -A INPUT -p tcp -d $serverip --destination-port 13306 -j DROP
	echo "Port 13306 with ip $userip add to iptables " 
fi

# creat user in mysql 

echo -e "Here User $USER will be added to mysql as a user"

if agree;then

	echo -n "$USER's Password in mysql : "
	read -s userpass1
	echo -n "Password Confirmation : "
	read -s userpass2

	if [ $userpass2 eq $userpass1 ];then

		# creating user in mysql
		echo "CREATE USER '$USER'@'$userip' identified by '$userpass1' REQUIRE SSL;" | sudo mysql -u root -p
		sleep 2
		echo "User $USER Created in mysql,Done!" 
		# give permissions to user
		echo "GRANT CREATE, DROP, INSERT, SELECT on *.* TO '$USER'@'$userip' WITH GRANT OPTION;" | sudo mysql -u root -p
		sleep 2
		echo "User $USER Granted with creat , insert and select privileges in mysql,Done!" 
		# confirm permissions to user
		echo "FLUSH PRIVILEGES;" | sudo mysql -u root -p
		echo "creating $USER and grant it to permissions all done!" 
	else
		echo "Pasword Doesnt match" 
		exit 1
	fi
fi

echo "All configs have been Done!" 

echo -e """Now you can connect to your database with this below command : \n
\'mysql -P 13306 -h $userip -u $USER -p\'
""" 

