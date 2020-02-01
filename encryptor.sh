#!/bin/bash
#a script to help automating encription & decryption data with password.
#please be careful when using this script to prevent undesirable happenings.
#dont forget use strong password otherwise encription will be useless.
#script functions
#encrypt all files & subfiles in entered direction
encrypt (){
  check
  if [[ -z $passwd ]]; then
    echo "please see help with -h"
    exit
  fi
  #warn user for sensetive directions
  if [[ $encdir == "/" ]] || [[ $encdir == "/home" ]] || [[ $encdir == "$HOME" ]] || [[ $encdir == "/root" ]] || [[ $encdir == "/boot" ]]; then
    echo "are you sure to encrypt all files in "$encdir" ? (y/n)"
    case $answer in
      y )
      #this continue encription
      ;;
      n )
      exit;;
      * )
      exit;;
    esac
  fi
  echo "$passwd" > "/tmp/temp.txt"
  cd "$encdir"
  for f in * ; do
    openssl aes-256-cbc -in $f -out $f.enc -pass pass:"$passwd"
    rm -rf "$f"
  done
  echo "all files encrypted successfully!"
  exit
}
#decrypt all files & subfiles in entered direction
decrypt (){
  check
  passwd=`cat "/tmp/temp.txt"`
  if [[ $password != $passwd ]]; then
    echo "password is wrong!"
    exit
  fi
  cd "$encdir"
  for f in * ; do
    fname="${f%.*}"
    openssl aes-256-cbc -d -in $f -out $fname -pass pass:"$passwd"
    rm -rf "$f"
  done
  echo "all files decrypted successfully!"
  rm -rf "/tmp/temp.txt"
  exit
}
#check if encrypt directory is null
check (){
  if [[ -z $encdir ]]; then
    echo "please see help with -h"
    exit
  fi
}
#script body
clear
#script's main options   e:encrypt   d:decrypt   h:help
while getopts "edh" switchs;do
  case $switchs in
  e )
  #script's sub options   o:set full path or direction   p:set password
  while getopts "o:p:" options;do
    case $options in
      o )
      encdir="$OPTARG"
      ;;
      p )
      passwd="$OPTARG"
      ;;
      * )
      echo "please see help with -h"
      exit
      ;;
    esac
  done
  encrypt
  ;;
  d )
  while getopts "o:p:" options;do
    case $options in
      o )
      encdir="$OPTARG"
      ;;
      p )
      password="$OPTARG"
      ;;
      * )
      echo "please see help with -h"
      exit
      ;;
    esac
  done
  decrypt
  ;;
  h )
  echo -e "help :use -e to encrypt or -d to decrypt\nuse -o to set full path or direction\nuse -p to set password"
  exit
  ;;
  * )
  echo "please see help with -h"
  exit
  ;;
esac
done
check
