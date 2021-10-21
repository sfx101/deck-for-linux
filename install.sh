#!/bin/sh
#Set up the required package
echo "**********************************************************************************";
echo "Update the apt package index and install packages to allow apt to use a repository over HTTPS:"
echo "**********************************************************************************";
sudo apt update
pkgs='curl uidmap apt-transport-https ca-certificates gnupg lsb-release'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install -y $pkgs
fi
pkgs='deck-app'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  wget https://github.com/sfx101/deck/releases/download/v3.0.0/DECK-3.0.0-amd64.deb
  sudo dpkg -i DECK-3.0.0-amd64.deb
fi
#Check prsent user Info
echo "check your user info";
id -u && whoami && grep ^$(whoami): /etc/subuid && grep ^$(whoami): /etc/subgid
#clear

#If you installed Docker 20.10 or later without RPM/DEB packages, you should have
echo "**********************************************************************************";
echo "If you installed Docker 20.10 or later without RPM/DEB packages, you should have ";
echo "**********************************************************************************";
curl -fsSL https://get.docker.com/rootless | sh
export PATH=/home/test/bin:$PATH
export DOCKER_HOST=unix:///run/user/$USER/docker.sock
sudo usermod -aG docker $USER
systemctl --user enable docker && sudo loginctl enable-linger $(whoami)
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
#clear

#Docker gpg add
echo "**********************************************************************************";
echo "Docker gpg add";
echo "**********************************************************************************";
FILE=/usr/share/keyrings/docker-archive-keyring.gpg
if [ -f "$FILE" ]; then 
	echo "$FILE exists"
else
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
fi
#Set up the stable repository.
echo "**********************************************************************************";
echo "Set up the stable repository.";
echo "**********************************************************************************";
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 #Install Docker Engine
echo "**********************************************************************************";
echo "Install Docker Engine";
echo "**********************************************************************************";
sudo apt-get update
pkgs='docker-ce docker-ce-cli containerd.io'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install -y $pkgs
fi
#clear

#List the versions available in your repo
echo "**********************************************************************************";
echo "List the versions available in your repo";
echo "**********************************************************************************";
apt-cache madison docker-ce
# Checking docker install in root user
echo "**********************************************************************************";
echo "Checking docker Install in root user";
echo "**********************************************************************************";
sudo docker run hello-world
# Group Add
echo "**********************************************************************************";
echo "Docker group Add"
echo "**********************************************************************************";
sudo usermod -aG docker $USER
#clear

#Repo Install
#echo "**********************************************************************************";
#echo "Repo Install";
#echo "**********************************************************************************";
#dockerd-rootless-setuptool.sh install
#Service start with user mode
echo "**********************************************************************************";
echo "Service start with user mode";
echo "**********************************************************************************";
systemctl --user start docker
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)
#Checking You need to specify either the socket path or the CLI context explicitly.
echo "**********************************************************************************";
echo "Checking You need to specify either the socket path or the CLI context explicitly.";
echo "**********************************************************************************";
#export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
docker run -d -p 8080:80 nginx
##Check and install docker compose####
#clear
echo "**********************************************************************************";
echo "##Check and install docker compose####";
echo "**********************************************************************************";
pkgs='docker-compose neofetch'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install -y $pkgs
fi
#clear

############## IF not started docker please run below command ################
echo "**********************************************************************************";
echo "IF not started docker please run below command";
echo "**********************************************************************************";
echo "sudo usermod -aG docker $USER";
sudo usermod -aG docker $USER
echo "systemctl --user start docker";
systemctl --user start docker
echo "systemctl --user enable docker";
systemctl --user enable docker
echo "If https not working"
sudo setcap 'cap_net_bind_service=+eip' /opt/DECK/deck-app
sudo sh -c "echo '/opt/DECK/' >> /etc/ld.so.conf.d/deck.conf"
sudo ldconfig
echo "sudo chmod 664 /var/run/docker.sock";
systemctl start docker
sudo chmod 666 /var/run/docker.sock

############### End of install#######################
#clear
neofetch
echo "**********************************************************************************";
echo "Thanking you select Deck + Docker Application";
echo "**********************************************************************************";
