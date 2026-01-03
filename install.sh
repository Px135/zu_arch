#!/bin/bash
# ============================================================
# Arch Linux Starter Pack - Completo
#
# Incluye:
# - Herramientas básicas del sistema
# - Desarrollo y terminal
# - AUR (yay)
# - Flatpak
# - Servicios esenciales
# - Aplicaciones de uso diario
# ============================================================

set -e

# ------------------------------------------------------------
# Comprobaciones iniciales
# ------------------------------------------------------------

if [ "$EUID" -eq 0 ]; then
  echo "No ejecutes este script como root"
  exit 1
fi

echo "  _____          _      _             _        _______ 
 |__  /   _ _ __(_)    / \   _ __ ___| |__    / /___ / 
   / / | | | '__| |   / _ \ | '__/ __| '_ \  / /  |_ \ 
  / /| |_| | |  | |  / ___ \| | | (__| | | | \ \ ___) |
 /____\__,_|_|  |_| /_/   \_\_|  \___|_| |_|  \_\____/ 
                                                       "

# ------------------------------------------------------------
# Funciones auxiliares
# ------------------------------------------------------------

install_pacman() {
  echo "pacman -> $*"
  sudo pacman -S --needed --noconfirm "$@"
}

install_flatpak() {
  echo "flatpak -> $1"
  flatpak install -y flathub "$1"
}

# ------------------------------------------------------------
# Actualización del sistema
# ------------------------------------------------------------

echo "Actualizando sistema..."
sudo pacman -Syu --noconfirm

# ------------------------------------------------------------
# Flatpak
# ------------------------------------------------------------

install_pacman flatpak

echo "Configurando Flathub..."
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

# ------------------------------------------------------------
# yay (AUR helper)
# ------------------------------------------------------------

if ! command -v yay &> /dev/null; then
  echo "Instalando yay..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay ya está instalado"
fi

# ------------------------------------------------------------
# Paquetes AUR
# ------------------------------------------------------------

yay -S --needed --noconfirm \
  brave-bin \
  proton-mail

# ------------------------------------------------------------
# Aplicaciones pacman
# ------------------------------------------------------------

install_pacman \
  prismlauncher \
  kdeconnect

# ------------------------------------------------------------
# Cambiar shell a zsh
# ------------------------------------------------------------

if [[ "$SHELL" != *"zsh"* ]]; then
  echo "Cambiando shell por defecto a zsh..."
  chsh -s "$(which zsh)"
fi

# ------------------------------------------------------------
# Aplicaciones Flatpak (uso diario)
# ------------------------------------------------------------

install_flatpak app.zen_browser.zen
install_flatpak org.upscayl.Upscayl
install_flatpak com.valvesoftware.Steam
install_flatpak dev.vencord.Vesktop
install_flatpak org.vinegarhq.Sober
install_flatpak com.vysp3r.ProtonPlus
install_flatpak org.gnome.Mines
install_flatpak md.obsidian.Obsidian
install_flatpak com.artemchep.keyguard
install_flatpak net.drawpile.drawpile
install_flatpak org.kde.kdenlive
install_flatpak org.gimp.GIMP
install_flatpak com.obsproject.Studio
install_flatpak com.rustdesk.RustDesk

# ------------------------------------------------------------
# Trinity Launcher (repositorio Flatpak externo)
# ------------------------------------------------------------

echo "Instalando Trinity Launcher..."

flatpak remote-add --if-not-exists trinity \
  https://trinity-flatpak.codeberg.page/com.trench.trinity.launcher.flatpakrepo

flatpak install -y flathub org.kde.Platform//6.9
flatpak install -y flathub io.qt.qtwebengine.BaseApp//6.9
flatpak install -y trinity com.trench.trinity.launcher

# ------------------------------------------------------------
# osu! (Winello)
# ------------------------------------------------------------

echo "Instalando osu! (Winello)..."

install_pacman git wget zenity xdg-desktop-portal

git clone https://github.com/NelloKudo/osu-winello.git
cd osu-winello
chmod +x osu-winello.sh
./osu-winello.sh
cd ..
rm -rf osu-winello

# ------------------------------------------------------------
# Final
# ------------------------------------------------------------

echo "Arch Starter Pack instalado correctamente"
echo "Reinicia sesión para aplicar el cambio de shell"
