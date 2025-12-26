# Arrera Update 

[English version](readme_en.md)

## Description du script

Script bash pour mettre à jour son système Linux. 

- Debian et Pop OS (utilisant apt)
- Fedora et RedHat Enterprise Linux (utilisant DNF)

Deux versions du script existent : une version qui met aussi à jour les Flatpak (Desktop) et l’autre ne les met pas à jour (Serveur).

/!\ Pour détecter sur quel système il se trouve, le script utilise la commande `cat /etc/os-release`. Il est donc assuré de fonctionner sur Debian (Raspberry Pi OS compris) et Fedora (Workstation). Il peut fonctionner sur les dérivés mais je ne peux pas l’assurer.

## Utilisation du script

### Sans installation

Vous pouvez utiliser le script de deux façons : soit en vous plaçant dans le dossier où se trouve le script, vous mettre en root et lancer :

#### Version desktop : 
```bash
./script_desktop.sh
```
#### Version serveur : 
```bash
./script_serveur.sh
```
## Avec installation 

La deuxième façon de l’utiliser est de lancer le script `install_script.sh`,
qui va s’occuper de copier, au choix, le script pour Desktop ou Serveur dans le dossier `/bin` de votre système Linux et de le renommer en `arr`.
Une fois le script installé, pour lancer Arrera Update, tapez :

```bash
arr
```