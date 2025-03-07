#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____             __         
   / __ \____ ______/ /_  __  __
  / / / / __  / ___/ __ \/ / / /
 / /_/ / /_/ (__  ) / / / /_/ / 
/_____/\__,_/____/_/ /_/\__, /  
                       /____/   
EOF
}
header_info
echo -e "Loading..."
APP="Dashy"
var_disk="6"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/dashy/public/ ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_error "There is currently no update path available."
exit
msg_info "Stopping ${APP}"
systemctl stop dashy
msg_ok "Stopped ${APP}"

msg_info "Backing up conf.yml"
cd ~
cp -R /dashy/public/conf.yml conf.yml
msg_ok "Backed up conf.yml"

msg_info "Updating Dashy"
cd /dashy
git merge &>/dev/null
git pull origin master &>/dev/null
yarn &>/dev/null
yarn build &>/dev/null
msg_ok "Updated Dashy"

msg_info "Restoring conf.yml"
cd ~
cp -R conf.yml /dashy/public
msg_ok "Restored conf.yml"

msg_info "Cleaning"
rm -rf conf.yml
msg_ok "Cleaned"

msg_info "Starting Dashy"
systemctl start dashy
msg_ok "Started Dashy"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:4000${CL} \n"
