# Arrera Update (English)

## Script Description

Bash script to update your Linux system.

- Debian and Pop!_OS (using apt)
- Fedora and Red Hat Enterprise Linux (using DNF)

Two versions of the script exist: one that also updates Flatpak (Desktop) and another that does not (Server).

/!\ To detect which system it is running on, the script uses `cat /etc/os-release`. It is therefore guaranteed to work on Debian (including Raspberry Pi OS) and Fedora (Workstation). It may work on derivatives, but I cannot guarantee it.

## Using the Script

### Without installation

You can use the script in two ways: either go to the folder where the script is located, become root, and run:

#### Desktop version:
```bash
./script_desktop.sh
```
#### Server version:
```bash
./script_serveur.sh
```

## With installation

The second way to use it is to run `install_script.sh`, which will copy, at your choice, the Desktop or Server script into the `/bin` folder of your Linux system and rename it to `arr`.
Once the script is installed, to launch Arrera Update, type:

```bash
arr
```
