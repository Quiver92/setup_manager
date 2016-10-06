#!/bin/bash

tput clear
tput setaf 3
echo "Chameleon Soft"
tput sgr0

#Title
(tput cup 5 17 ; tput bold ; echo "====================================" ; 
tput cup 6 27 ; tput bold ; echo "Menu to Setup" ; 
tput cup 7 17 ; tput bold ; echo "====================================")
#Choices
(tput cup 9 5 ; tput setaf 4 ; echo "Enter 1 to setup teamviewer" ;
tput cup 10 5 ; tput setaf 4 ; echo "Enter 2 to setup skype" ; 
tput cup 11 5 ; tput setaf 4 ; echo "Enter 3 to setup chameleon" ;
tput cup 12 5 ; tput setaf 5 ; echo "Enter q to exit" ;  
tput cup 14 5 ; echo -e "Enter your selection:")
#Answer
tput cup 14 27
read answer
tput clear
tput sgr0

case "$answer" in

#Setup teamviewer
1) sudo rm -rf /mnt/teamviewer* && sudo apt-get install -f && sudo apt-get -y install libxtst6:i386 libxrandr2:i386 && sudo apt-get update && sudo apt-get install -f && cd /mnt/ && sudo wget https://download.teamviewer.com/download/teamviewer_i386.deb && cd /mnt && sudo dpkg -i /mnt/teamviewer* && sudo rm -rf /mnt/teamviever* ;;

#Setup skype
2) sudo apt-get install -f && sudo apt-get install sni-qt:i386 libdbusmenu-qt2:i386 libqt4-dbus:i386 libxss1:i386 && sudo apt-get update && sudo apt-get install libgtk2.0-0:i386 gtk2-engines:i386 libgconf-2-4:i386 && sudo apt-get install -f && sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" && sudo apt-get update && sudo apt-get install skype ;;

##Installation of Chameleon
3) whiptail --title "Example Dialog" --msgbox "Now will be installed addiional components. It takes less than a minute. You must hit OK to continue." 8 78
##Checking key and adding it
 APTKEY=$(3>&1 apt-key list>&3 |  awk '{ print $2 }' | grep 1024D/838F7C88)
 if [ $APTKEY -eq 0 ]
   then
     apt-key adv --recv-keys --keyserver keys.gnupg.net 1FB50E9B838F7C88
   else
     echo "You already add key"
 fi
 ##The code name of the distribution, and adds to the repository /etc/apt/souces.list
 if [ 3>&1 dpkg -s python-software-properties software-properties-common>&3 | grep "Status: install ok installed" -eq 0 ]
   then
    sudo apt-get install python-software-properties software-properties-common
   else
    echo "You already install python-software-properties and software-properties-common"
 fi
 DISTR_CODENAME=$(awk -F "=" '{ print $2 }' /etc/lsb-release | sed -n  '3p')
 sudo add-apt-repository "deb http://repos.chmsoft.com.ua/ "$DISTR_CODENAME"-evolution-2.5 non-free"
sudo apt-get update

PACKAGES=$(whiptail --title "Software Selection" --checklist \
"Choose packets to install:" 20 78 6 \
"chameleon-spring" "                                 "  ON \
"chameleon-fruti" "                                 " OFF \
"chameleon-server" "                                 " OFF 3>&1 1>&2 2>&3) 
exitstatus=$?
if [ $exitstatus = 0 ]; then
  echo "You choose:" $PACKAGES
 else
  echo "You choose cancel."
fi
PACKAGES_NEW=$(printf '%s' $PACKAGES | tr -d \") 
if [ "$PACKAGES_NEW"="chameleon-spring" ]
then
sudo apt-get install chameleon-client chameleon-spring 
elif [ "$PACKAGES_NEW"="chameleon-fruti" ]
then
sudo apt-get install chameleon-client chameleon-fruti
elif [ "$PACKAGES_NEW"="chameleon-server" ]
then
sudo apt-get install chameleon-server
else 'You chose cancel'
exit 0
fi
;;
q) exit ;;
esac

