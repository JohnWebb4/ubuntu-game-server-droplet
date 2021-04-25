#!/usr/bin/env bash

. '../utils/loadenv.sh'

main() {
  if [ -z "$name" ]; then
    echo 'You must enter a server name.'
    exit 1
  fi

  if [ -z "$world" ]; then
    echo 'You must enter a world name.'
    exit 1
  fi

  if [ -z "$password" ]; then
    echo 'You must enter a password.'
    exit 1
  fi

  pushd "$HOME/Valheim"

  export templdpath=$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
  export SteamAppId=892970

  echo "Starting server with name:'$name' world:'$world' password:'$password'"

  ./valheim_server.x86_64 -nographics -batchmode -name "$name" -world "$world" -password "$password"

  export LD_LIBRARY_PATH=$templdpath

  popd
}

main
