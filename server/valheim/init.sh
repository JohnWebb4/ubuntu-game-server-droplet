#!/usr/bin/env sh

main() {
  if [ "$(ifAlreadyInstalled 'steamcmd')" ]; then
    echo 'Steam CLI already installed'
  else
    installSteam
  fi

  if [ -f "$HOME/Valheim/valheim_server.x86_64" ]; then
    echo 'Valheim server already installed'
  else
    installService
  fi

  writeService

  setupService
}

installSteam() {
  echo 'Installing Steam tool'

  sudo add-apt-repository multiverse
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install lib32gcc-s1 steamcmd 

  sudo apt install steamcmd
}

installService() {
  echo 'Installing Valheim server'

  mkdir ~/Valheim

  steamcmd +login anonymous +force_install_dir ~/Valheim +app_update 896660 validate +exit
}

writeService() {
  cat >valheim.service <<EOL
  [Unit]
  Description = Valheim game service

  [Service]
  Type=simple
  Restart=on-failure
  RestartSec=5
  StartLimitInterval=60s
  StartLimitBurst=3
  User=$(whoami)
  Group=$(whoami)
  WorkingDirectory=$(pwd)
  ExecStart=$(pwd)/valheim_server.sh
  ExecStop=/bin/killall -TERM valheim_server
  LimitNOFILE=100000

  [Install]
  WantedBy=multi-user.target
EOL
}

setupService() {
  echo 'Setup Valheim service'

  sudo ufw allow 2456:2458/udp
  sudo ufw allow 2456:2458/tcp

  folder="/lib/systemd/system"

  if [ -f "$folder/valheim.service" ]; then
    sudo rm "$folder/valheim.service"
    systemctl daemon-reload
  fi

  echo "Symlinking from $(pwd) to $folder"

  sudo cp "$(pwd)/valheim.service" "$folder/valheim.service"

  systemctl enable valheim.service
  systemctl start valheim
  
  systemctl status valheim
}

ifAlreadyInstalled() {
  package_command="$1"

  if [ -n "$package_command" ]; then
    if [ "$(command -v "$package_command")"  ]; then
      echo true
      return 0
    fi
  fi

  return 1
}

main
