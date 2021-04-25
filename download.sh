#! /usr/bin/env sh

. './loadenv.sh'

path=$1
output=$2

if [ -z "$path" ]; then
  echo 'You must enter a source'
  exit 1
fi

if [ -z "$output" ]; then
  echo 'You must enter a destination folder'
  exit 1
fi

echo "Download folder $path from $ip to $output"
scp -P $port -r "$user@$ip:$path" "$output"

