#!/bin/bash

echo "------------------- Arrera Update -------------------" ;
echo "[INFO] Mise a jour de votre systeme et vos flatpack" ;
echo "[WARMING] Le script demande de s'executer avec le droit sudo ou en root";
sudo dnf update -y 
sudo flatpak update -y
echo "[OK] Mise a jour terminer "

while true; do

echo "[QUESTION] Voulez-vous redemarer votre ordinateur [1:Oui,2:Non] $" ;
read userInput

if [ "$userInput" = 1 ]; then
    break
  elif [ "$userInput" = 2 ]; then
    break
  fi
done

echo "[INFO] Votre odinateur est a jour";

if [ "$userInput" = 1 ];then

echo "[INFO] Votre odinateur vas redemarer";
reboot 

fi