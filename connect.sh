#! /usr/bin/env sh

. './loadenv.sh'

echo "Connecting to $user at $ip on $port"
ssh $user@$ip -p $port
