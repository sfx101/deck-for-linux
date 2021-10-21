#!/bin/sh
sudo apt-get purge -y docker docker.io docker-ce docker-ce-cli containerd.io docker-compose
sudo apt-get autoremove -y --purge docker docker.io docker-ce
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
clear
echo "**********************************************************************************";
echo "Thanking you select Deck Application";
echo "**********************************************************************************";
neofetch
zenity --notification --window-icon="info" --title "Uninstall Completed" --text="<b>Docker uninstall completed, You can Install docker. Do you contanue</b> "
