#!/bin/sh

do_stow() {
string=$1
ch="#"
cmd=" -D "
result=$(echo $string | grep "${ch}")
if [[ "$result" != "" ]]; then
  cmd="$cmd $string -t "
  right=${string#*$ch}
  if [ "$right" == "" ]; then
    cmd="$cmd/"
  else
    array=(${right//#/ })
    for var in ${array[@]}
    do
      cmd="$cmd/$var"
    done
  fi
else
  cmd="$cmd $string"
fi
echo "stow $cmd"
sudo stow $cmd
}

if [ $# == 0 ]; then
  for file in $(ls)
  do
    if [ -d $file ]; then
      do_stow $file
    fi
  done
else
  for i in "$@"; do
    do_stow $i
  done
fi
