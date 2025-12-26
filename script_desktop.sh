#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'
LOG_DNF="/tmp/arrera_dnf_upgrade.log"
LOG_APT="/tmp/arrera_apt_upgrade.log"

draw_banner() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "  █████╗ ██████╗ ██████╗ ███████╗██████╗  █████╗ "
    echo " ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗"
    echo " ███████║██████╔╝██████╔╝█████╗  ██████╔╝███████║"
    echo " ██╔══██║██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║"
    echo " ██║  ██║██║  ██║██║  ██║███████╗██║  ██║██║  ██║"
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${CYAN}"
    echo " ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
    echo " ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
    echo " ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
    echo " ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
    echo " ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
    echo "╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${NC}"
}

# Affiche un spinner pendant l'exécution d'une commande longue
run_with_spinner() {
  local msg="$1"; shift
  "$@" &
  local pid=$!
  local spin='|/-\'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "$msg" "${spin:i++%${#spin}:1}"
    sleep 0.1
  done
  wait "$pid"
  local status=$?
  printf "\r%s ... fait\n" "$msg"
  return $status
}


update_dnf(){
  echo -e "${CYAN}[INFO]${NC} Liste des paquets à mettre à jour :"
  sudo dnf check-update || true
  echo
  : >"$LOG_DNF"
  if run_with_spinner "Mise à jour dnf (log: $LOG_DNF)" bash -c "dnf upgrade -y >'$LOG_DNF' 2>&1"; then
    echo -e "${GREEN}[OK] Mise à jour terminée${NC}"
    echo -e "${CYAN}[INFO]${NC} Dernières lignes du log :"
    tail -n 8 "$LOG_DNF"
  else
    echo -e "${RED}[ERREUR] La mise à jour dnf a échoué${NC}"
    echo -e "${CYAN}[INFO]${NC} Consulte le log : $LOG_DNF"
    tail -n 20 "$LOG_DNF"
  fi
}

update_apt(){
    echo -e "${CYAN}[INFO]${NC} Mise à jour de l'index APT..."
    if ! run_with_spinner "apt update" sudo apt update; then
      echo -e "${RED}[ERREUR] apt update a échoué${NC}"
      return 1
    fi

    echo -e "${CYAN}[INFO]${NC} Liste des paquets à mettre à jour :"
    apt list --upgradable
    echo

    : >"$LOG_APT"
    if run_with_spinner "Mise à jour apt (log: $LOG_APT)" bash -c "sudo apt upgrade -y >'$LOG_APT' 2>&1"; then
      echo -e "${GREEN}[OK] Mise à jour terminée${NC}"
      echo -e "${CYAN}[INFO]${NC} Dernières lignes du log :"
      tail -n 8 "$LOG_APT"
    else
      echo -e "${RED}[ERREUR] La mise à jour apt a échoué${NC}"
      echo -e "${CYAN}[INFO]${NC} Consulte le log : $LOG_APT"
      tail -n 20 "$LOG_APT"
    fi
  }

update_flatpak(){
    echo -e "${CYAN}[INFO]${NC} Mise à jour des paquets Flatpak..."
    if run_with_spinner "Mise à jour Flatpak" flatpak update -y; then
      echo -e "${GREEN}[OK] Mise à jour Flatpak terminée${NC}"
    else
      echo -e "${RED}[ERREUR] La mise à jour Flatpak a échoué${NC}"
    fi
}

arrera_update() {
  os_id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
  if [ "$os_id" = "debian" ]; then
    echo -e "Mise a jour de ${PURPLE}Debian${NC}";
    update_apt
    update_flatpak
  elif [ "$os_id" = "fedora" ]; then
    echo -e "Mise a jour de ${BLUE}Fedora${NC}";
    update_dnf
    update_flatpak
  elif [ "$os_id" = "pop" ];then
    echo -e "Mise a jour de ${CYAN}Pop!_OS${NC}";
    update_apt
    update_flatpak
  elif [ "$os_id" = "rhel" ]; then
    echo -e "Mise a jour de ${RED}Red Hat Enterprise Linux${NC}";
    update_dnf
    update_flatpak
  else
    echo -e "${RED}[ERREUR] Impossible de détecter la distribution ou la distribution n'est pas prise en charge.${NC}"
  fi
}

main(){
  draw_banner
  echo -e "${BOLD}${CYAN}──────────── Arrera Update ────────────${NC}" ;
  echo -e "${RED}[INFO]${NC} Mise a jour de votre systeme et vos flatpack" ;
  echo -e "${YELLOW}[WARMING]${NC} Le script demande de s'executer avec le droit sudo ou en root";
  arrera_update
}

main