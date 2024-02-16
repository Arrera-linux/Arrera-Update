#!/bin/bash

echo "------------------- Arrera Update -------------------" ;
echo "[INFO] Mise a jour de votre systeme et vos flatpack" ;
echo "[WARMING] Le script demande de s'executer avec le droit sudo ou en root";

#Detection du syteme
if [ -f "/etc/os-release" ]; then
    # Extraire l'identifiant de la distribution depuis le fichier /etc/os-relea>
    os_id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')

    # Vérifier si l'identifiant correspond à Debian
    if [ "$os_id" = "debian" ]; then
        sudo apt update 
        sudo apt upgrade -y
        sudo flatpak update -y
        echo "[OK] Mise a jour terminer "
    # Vérifier si l'identifiant correspond à Fedora
    elif [ "$os_id" = "fedora" ]; then
      sudo dnf update -y 
      sudo flatpak update -y
      echo "[OK] Mise a jour terminer "

  # Update fedora 
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
    else
        echo "Impossible de mettre a jour votre distribution"
    fi
else
    echo "Impossible de mettre a jour votre distribution"
fi






