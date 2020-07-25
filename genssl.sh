#!/bin/bash

function checkValid() {
  if [[ -n $email ]]; then
    return 0
  else
    return 1
  fi
}

function genSSL() {
  echo "Generating key request for $domain"
  mkdir -p $HOME/Desktop/ssl/$domain
  #Generate a private key
  openssl genrsa -out $HOME/Desktop/ssl/$domain/$domain-$TIME.key 2048
  #Create the csr
  echo "Creating CSR"
  openssl req -new -key $HOME/Desktop/ssl/$domain/$domain-$TIME.key -out $HOME/Desktop/ssl/$domain/$domain-$TIME.csr \
      -subj "/C=$country/ST=$state/O=$organization/OU=$organizationalunit/CN=$domain/emailAddress=$email"
  #Print output
  echo "-----Below is your CSR-----"
  echo
  cat /home/khanhtruong/Desktop/ssl/$domain/$domain-$TIME.csr
  echo
  echo "-----Below is your Private Key-----"
  echo
  cat /home/khanhtruong/Desktop/ssl/$domain/$domain-$TIME.key
  echo
  echo "Your CSR and Private Key is saved to $HOME/Desktop/ssl/$domain"
  echo
}

function main(){
	#Varible input
	domain=$1
	email=$2
	#Constant for gen csr
	country="VN"
	state="Ho Chi Minh"
	organization="Vietnix JSC"
	organizationalunit="IT"
	TIME=$(date +"%Y%m%d")

  if checkValid; then
    genSSL
  else
    echo "Abort. Try again using syntax ./genssl [Domain] [Email]"
  fi
}

main "$@"
