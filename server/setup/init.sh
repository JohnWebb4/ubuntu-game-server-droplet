#! /usr/bin/env sh

. '../utils/loadenv.sh'

main() {
  if [ -z "$user" ]; then
    echo 'You must enter a username.'
    exit 1
  fi

  if [ -z "$port" ]; then
    echo 'You must enter an ssh port.'
    exit 1
  fi

  echo "Configuring the server for $user on ssh port $port"

  if grep -q USER_CONFIGURED config.txt; then
    echo "User added: $user"
  else
    addUser "$user"

    echo 'USER_CONFIGURED' >> config.txt
  fi

  if grep -q SSH_CONFIGURED config.txt; then
   echo 'SSH Configured'
  else
    configureSsh "$user"

    echo 'SSH_CONFIGURED' >> config.txt
    exit
  fi

  if grep -q USER_SETUP config.txt; then
    echo 'User configured'
  else
    setupUser
    
    echo 'USER_SETUP' >> config.txt
  fi


  if grep -q FIREWALL_SETUP config.txt; then
    echo 'Firewall configured'
  else
    setupFirewall

    echo 'FIREWALL_SETUP' >> config.txt
  fi
}

addUser() {
  user="$1"

  echo "Adding user $user"
  return

  useradd -m "$user"
  usermod -aG sudo "$user" 
  passwd "$user"

  # Login as user
  echo "Let's test that you can login"
  sudo -u "$user" echo 'You can login'
}

configureSsh() {
  user="$1"

  echo "Configuring SSH for $user"

  mkdir ~/.ssh
  cp '/root/.ssh/authorized_keys' "/home/$user/.ssh/"
  chown -R "$user:users" "/home/$user/.ssh"

  echo "This next part is manual. Cuz I don't wanna mess stuff up."

  echo "Verify you can login as that user"

  echo "WHEN READY Replace PermitRootLogin yes with PermitRootLogin no in /etc/ssh/sshd_config"
  echo "WHEN READY Run 'sudo systemctl restart ssh'"

  echo "Verify you can login as that user"

  echo "WHEN READY Replace PORT 22 with PORT ####"
  echo 'WHEN READY Add Protocol 2'
  echo 'WHEN READY Switch AllowTcpForwarding and X11Forwarding to no'
  echo "WHEN READY Run 'sudo systemctl restart ssh'"

  echo "Then next time you run this it'll continue"
  echo "If it doesn't work, you can always connect through the dev console"
}

setupUser() {
  echo 'Setting up user'

  mkdir Documents
}

setupFirewall() {
  echo 'Setting up UFW firewall'

  sudo ufw enable

  echo 'Enter the SSH Port: '
  sudo ufw allow "$port"

  echo 'Verify the firewall is active. Press enter to continue'
  sudo ufw status
}

main $@
