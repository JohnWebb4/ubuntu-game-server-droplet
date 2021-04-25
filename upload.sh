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

echo "Upload folder $path to $output"
scp -P $port -r "$path" "$user@$ip:$output"

