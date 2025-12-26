#!/bin/bash

set -euo pipefail

SCRIPT_NAME="arr"
DEST="/bin/${SCRIPT_NAME}"

# Vérifie que l'exécution se fait en root
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
	echo "[ERREUR] Ce script doit être lancé en root (sudo ou root)." >&2
	exit 1
fi

script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
desktop_script="${script_dir}/script_desktop.sh"
server_script="${script_dir}/script_serveur.sh"

echo "[QUESTION] Quelle version installer ?"
echo "1) Desktop"
echo "2) Serveur"
read -r choice

case "$choice" in
	1)
		source_script="$desktop_script"
		;;
	2)
		source_script="$server_script"
		;;
	*)
		echo "[ERREUR] Choix invalide (répondez 1 ou 2)." >&2
		exit 1
		;;
esac

if [ ! -f "$source_script" ]; then
	echo "[ERREUR] Script source introuvable : $source_script" >&2
	exit 1
fi

echo "[INFO] Installation de ${SCRIPT_NAME} dans ${DEST}"
install -m 755 "$source_script" "$DEST"

echo "[OK] Installation terminée. Vous pouvez lancer : ${SCRIPT_NAME}"