#!/bin/bash
# Travis CI Generating and Building for the Nginx Ultimate Bad Bot Blocker (using non standard folder locations)
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/KimSpecht/nginx-ultimate-bad-bot-blocker

##############################################################################                                                                
#       _  __     _                                                          #
#      / |/ /__ _(_)__ __ __                                                 #
#     /    / _ `/ / _ \\ \ /                                                 #
#    /_/|_/\_, /_/_//_/_\_\                                                  #
#       __/___/      __   ___       __     ___  __         __                #
#      / _ )___ ____/ /  / _ )___  / /_   / _ )/ /__  ____/ /_____ ____      #
#     / _  / _ `/ _  /  / _  / _ \/ __/  / _  / / _ \/ __/  '_/ -_) __/      #
#    /____/\_,_/\_,_/  /____/\___/\__/  /____/_/\___/\__/_/\_\\__/_/         #
#                                                                            #
##############################################################################                                                                

# ------------------------------------------------------------------------------
# MIT License
# ------------------------------------------------------------------------------
# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza
# ------------------------------------------------------------------------------
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# ------------------------------------------------------------------------------
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# ------------------------------------------------------------------------------
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------

# ------------------------
# Set Terminal Font Colors
# ------------------------

bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
defaultcolor=$(tput setaf default)

# ---------
# FUNCTIONS
# ---------

reloadNginX () {
printf "\n"
echo "${bold}${green}---------------"
echo "${bold}${green}Reloading Nginx"
echo "${bold}${green}---------------"
sudo nginx -t && sudo nginx -s reload
}

waitforReload () {
echo "${bold}${yellow}-----------------------------------------------------------------------"
echo "${bold}${yellow}Sleeping for 10 seconds to allow Nginx to Properly Reload inside Travis"
echo "${bold}${yellow}-----------------------------------------------------------------------"
printf "\n"
sleep 10s
}

installNginxMainstream (){
sudo rm -rfv /etc/nginx-rc/mybots.d/
sudo rm -rfv /etc/nginx-rc/myconf.d/
sudo rm -rfv /etc/nginx-rc/conf.d/
sudo rm -rfv /etc/nginx-rc/bots.d/
sudo rm /etc/nginx-rc/sites-available/*
sudo rm /etc/nginx-rc/sites-enabled/*
sudo rm /etc/nginx-rc/nginx.conf
ls -la /etc/nginx-rc/
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/test1_conf_backup_nginxconf/nginx13.conf /etc/nginx-rc/nginx.conf
sudo apt-get purge nginx-full
sudo apt-get purge nginx-common
sudo apt-get purge nginx*

# Mainline from PPA
#mainstreamnginx=development
#sudo add-apt-repository -y ppa:nginx/${mainstreamnginx}
#sudo apt-get update
#sudo apt-get install -y --assume-yes nginx-full
#sudo nginx -V
#sudo nginx -t && sudo nginx -s reload

# Mainline from Nginx
stablenginx=stable
sudo add-apt-repository -y --remove ppa:nginx/${stablenginx}
mainstreamnginx=development
sudo add-apt-repository -y --remove ppa:nginx/${mainstreamnginx}
sudo sh -c "echo 'deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx' > /etc/apt/sources.list.d/nginx.list"
sudo wget https://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt -y update
sudo apt remove nginx nginx-common nginx-full nginx-core nginx*
sudo apt -y install nginx
sudo nginx -V
sudo nginx -t && sudo nginx -s reload
sudo mkdir /etc/nginx-rc/conf.d
sudo mkdir /etc/nginx-rc/bots.d
sudo mkdir /etc/nginx-rc/sites-available/
sudo mkdir /etc/nginx-rc/sites-enabled/
}

cleanupNginx1 () {
echo "${bold}${yellow}----------------------------------------------"
echo "${bold}${yellow}Removing Files from Install Nginx Mainline PPA"
echo "${bold}${yellow}----------------------------------------------"
printf "\n"
sudo rm /etc/nginx-rc/sites-available/default.vhost
sudo rm /etc/nginx-rc/sites-enabled/default.vhost
sudo rm /etc/nginx-rc/sites-available/*
sudo rm /etc/nginx-rc/sites-enabled/*
sudo rm /var/www/html/*
sudo rm /etc/nginx-rc/conf.d/*.conf
sudo rm /etc/nginx-rc/bots.d/*.conf
}

checkDirectories () {
ls -la /etc/nginx-rc/conf.d/
ls -la /etc/nginx-rc/bots.d/
ls -la /etc/nginx-rc/sites-available/
ls -la /etc/nginx-rc/sites-enabled/
ls -la /var/www/html/
echo "${bold}${yellow}------------------------------------------------------------"
echo "${bold}${yellow}Confirming Files from Install Nginx Mainline PPA are Removed"
echo "${bold}${yellow}------------------------------------------------------------"
printf "\n"
}

activateVHost () {
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/default.vhost /etc/nginx-rc/sites-available/default.vhost
sudo ln -s /etc/nginx-rc/sites-available/default.vhost /etc/nginx-rc/sites-enabled/default.vhost
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/index.html /var/www/html/index.html
echo "${bold}${yellow}---------------------------------------------"
echo "${bold}${yellow}Activating default.vhost and linking to Nginx"
echo "${bold}${yellow}---------------------------------------------"
printf "\n"
}

activateVHost2 () {
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/default-noincludes.vhost /etc/nginx-rc/sites-available/default.vhost
echo "${bold}${yellow}---------------------------------------------"
echo "${bold}${yellow}Activating default.vhost and linking to Nginx"
echo "${bold}${yellow}---------------------------------------------"
printf "\n"
}

getinstallngxblocker () {
echo "${bold}${magenta}--------------------------------------"
echo "${bold}${magenta}Fetch install-ngxblocker from the repo"
echo "${bold}${magenta}--------------------------------------"
printf "\n"
sudo wget https://raw.githubusercontent.com/KimSpecht/nginx-ultimate-bad-bot-blocker/master/install-ngxblocker -O /usr/sbin/install-ngxblocker
sudo chmod +x /usr/sbin/install-ngxblocker
}

runinstallngxblocker () {
echo "${bold}${magenta}--------------------------"
echo "${bold}${magenta}Execute install-ngxblocker"
echo "${bold}${magenta}--------------------------"
printf "\n"
cd /usr/sbin
sudo bash ./install-ngxblocker -x
}

makeScriptsExecutable () {
sudo chmod +x /usr/sbin/install-ngxblocker
sudo chmod +x /usr/sbin/setup-ngxblocker
sudo chmod +x /usr/sbin/update-ngxblocker
}

runsetupngxblocker1 () {
printf "\n"
echo "${bold}${magenta}------------------------"
echo "${bold}${magenta}Execute setup-ngxblocker"
echo "${bold}${magenta}------------------------"
printf "\n"
cd /usr/sbin
sudo bash ./setup-ngxblocker -x
}

loadNginxConf () {
printf "\n"
echo "${bold}${magenta}---------------"
echo "${bold}${magenta}Load nginx.conf"
echo "${bold}${magenta}---------------"
sudo nginx -c /etc/nginx-rc/nginx.conf
}

forceUpdateTest1 () {
printf "\n"
echo "${bold}${yellow}----------------------------------------------------"
echo "${bold}${yellow}Copy older globalblacklist.conf file to force update"
echo "${bold}${yellow}----------------------------------------------------"
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/globalblacklist-dummy.conf /etc/nginx-rc/conf.d/globalblacklist.conf
}

forceUpdateTest2 () {
echo "${bold}${yellow}--------------------------------------"
echo "${bold}${yellow}Delete Files to test update-ngxblocker"
echo "${bold}${yellow}--------------------------------------"
printf "\n"
sudo rm /etc/nginx-rc/conf.d/*.conf
sudo rm /etc/nginx-rc/bots.d/*.conf
ls -la /etc/nginx-rc/conf.d/
ls -la /etc/nginx-rc/bots.d/
}

runupdatengxblocker () {
printf "\n"
echo "${bold}${magenta}-------------------------"
echo "${bold}${magenta}Execute update-ngxblocker"
echo "${bold}${magenta}-------------------------"
cd /usr/sbin
sudo bash ./update-ngxblocker -n
}

activateLatestBlacklist () {
echo "${bold}${yellow}------------------------------------------------------------"
echo "${bold}${yellow}Make sure we test with latest generated globalblacklist.conf"
echo "${bold}${yellow}------------------------------------------------------------"
printf "\n"
sudo cp ${TRAVIS_BUILD_DIR}/conf.d/globalblacklist.conf /etc/nginx-rc/conf.d/globalblacklist.conf
}

backupConfFiles () {
printf "\n"
echo "${bold}${green}-------------------------------------------------------"
echo "${bold}${green}Backup all conf files and folders used during this test"
echo "${bold}${green}-------------------------------------------------------"
printf "\n"
sudo cp /etc/nginx-rc/bots.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/test5_conf_files/bots.d/
sudo cp /etc/nginx-rc/conf.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/test5_conf_files/conf.d/
sudo cp /etc/nginx-rc/sites-available/default.vhost ${TRAVIS_BUILD_DIR}/.dev-tools/test5_conf_files/default.vhost
sudo cp /etc/nginx-rc/nginx.conf ${TRAVIS_BUILD_DIR}/.dev-tools/test5_conf_files/nginx.conf
}

getnginxversion () {
sudo nginx -v &> ${TRAVIS_BUILD_DIR}/.dev-tools/nginxv3.txt
}

copyNginxConf () {
printf "\n"
echo "${bold}${magenta}------------------------------"
echo "${bold}${magenta}Copy nginx.conf to /etc/nginx-rc/"
echo "${bold}${magenta}------------------------------"
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/nginx.conf-newformat /etc/nginx-rc/nginx.conf
}

cleanupNginxKeys () {
sudo rm ${TRAVIS_BUILD_DIR}/nginx_signing.key*
}

# -----------------
# Trigger Functions
# -----------------

installNginxMainstream
checkDirectories
activateVHost
getinstallngxblocker
makeScriptsExecutable
runsetupngxblocker1
loadNginxConf
forceUpdateTest1
runupdatengxblocker
reloadNginX
waitforReload
forceUpdateTest2
runupdatengxblocker
checkDirectories
forceUpdateTest1
runupdatengxblocker
runsetupngxblocker1
reloadNginX
waitforReload
activateVHost2
runsetupngxblocker1
reloadNginX
waitforReload
activateLatestBlacklist
copyNginxConf
runsetupngxblocker1
reloadNginX
waitforReload
backupConfFiles
getnginxversion
cleanupNginxKeys

# ----------------------
# Exit With Error Number
# ----------------------

exit ${?}

# ------------------------------------------------------------------------------
# MIT License
# ------------------------------------------------------------------------------
# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza
# ------------------------------------------------------------------------------
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# ------------------------------------------------------------------------------
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# ------------------------------------------------------------------------------
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------
