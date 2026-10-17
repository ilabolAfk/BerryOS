#!/bin/bash
# ============================================================
# Berry OS — Часть 1: Ядро, Терминал, Plymouth, Темы
# ============================================================

set -e
BIN="/usr/local/bin"
TOOLS="/usr/local/bin/berry-tools"
SRC_LOGO="/root/mint-minimal/logo.png"

echo "[1/5] Создание структуры и утилит..."
sudo mkdir -p "$TOOLS"
echo "3.1" | sudo tee /etc/berry-version > /dev/null

# --- berry-info ---
sudo tee "$TOOLS/berry-info" > /dev/null << 'EOF'
#!/bin/bash
GREEN='\033[1;32m'; CYAN='\033[1;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${GREEN}Berry OS${NC} — версия $(cat /etc/berry-version)"
echo -e "${CYAN}Мощная операционная система${NC}"
echo -e "${YELLOW}Ядро:${NC} $(uname -r) | ${YELLOW}Аптайм:${NC} $(uptime -p | sed 's/up //')"
echo -e "${YELLOW}CPU:${NC} $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.0f", 100 - $1}')% | ${YELLOW}RAM:${NC} $(free -h | awk '/^Mem:/ {print $3}') / $(free -h | awk '/^Mem:/ {print $2}')"
EOF

# --- berry-update ---
sudo tee "$BIN/berry-update" > /dev/null << 'EOF'
#!/bin/bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove --purge -y && sudo apt clean
EOF

# --- berry-clean ---
sudo tee "$BIN/berry-clean" > /dev/null << 'EOF'
#!/bin/bash
sudo rm -rf /tmp/* /var/tmp/* && sudo journalctl --vacuum-time=3d
EOF

# --- berry-doctor ---
sudo tee "$BIN/berry-doctor" > /dev/null << 'EOF'
#!/bin/bash
echo -e "\033[1;36m=== Berry Doctor ===\033[0m"
echo "[1] Пакеты:"; dpkg -C || echo "OK"
echo "[2] Диск:"; df -h / | tail -1
echo "[3] Память:"; free -h | grep Mem
EOF

sudo chmod +x "$TOOLS"/* "$BIN"/berry-*
for tool in berry-info; do sudo ln -sf "$TOOLS/$tool" "$BIN/$tool"; done

echo "[2/5] Настройка алиасов..."
sudo tee /etc/profile.d/berry-aliases.sh > /dev/null << 'EOF'
alias ll='ls -lah'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade -y'
alias install='sudo apt install'
alias binfo='berry-info'
alias bupdate='berry-update'
alias bclean='berry-clean'
alias doctor='berry-doctor'
alias extract='berry-extract'
alias mem='free -h'
alias cpu='top -bn1 | head -20'
EOF
sudo chmod +x /etc/profile.d/berry-aliases.sh

echo "[3/5] Установка тем и иконок (Papirus, Zorin)..."
# Установка Papirus
sudo add-apt-repository -y ppa:papirus/papirus
sudo apt update && sudo apt install -y papirus-icon-theme git
# Установка Zorin Controls
cd /tmp && git clone --depth 1 https://github.com/ZorinOS/zorin-desktop-themes.git
sudo cp -r /tmp/zorin-desktop-themes/ZorinBlue-Light /usr/share/themes/
rm -rf /tmp/zorin-desktop-themes

# Фиксация настроек
sudo tee /usr/share/glib-2.0/schemas/zz_berry-settings.gschema.override > /dev/null << 'EOF'
[org.cinnamon.desktop.interface]
gtk-theme='ZorinBlue-Light'
icon-theme='Papirus'
[org.cinnamon.theme]
name='Mint-Y'
[org.cinnamon.desktop.wm.preferences]
theme='Mint-Y'
EOF
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "[4/5] Настройка Plymouth..."
if [ -f "$SRC_LOGO" ]; then
    PLYMOUTH_DIR="/usr/share/plymouth/themes/mint-logo"
    if [ -d "$PLYMOUTH_DIR" ]; then
        cd "$PLYMOUTH_DIR"
        for f in animation-*.png throbber-*.png watermark.png; do
            [ -f "$f" ] && sudo cp "$SRC_LOGO" "$f"
        done
        sudo update-initramfs -u
    fi
else
    echo "  ! Логотип не найден, Plymouth пропущен."
fi

echo "[5/5] Фикс иконок меню и ярлыков..."
ICON_DIR="/usr/share/icons/hicolor/256x256/apps"
sudo mkdir -p "$ICON_DIR"
ICON_PATH="$ICON_DIR/berry-logo.png"
if [ -f "$SRC_LOGO" ]; then
    sudo cp "$SRC_LOGO" "$ICON_PATH"
    sudo gtk-update-icon-cache -f -t /usr/share/icons/hicolor
    
    # Апплет меню
    APPLET_CONF="/usr/share/cinnamon/applets/menu@cinnamon.org/settings-override.json"
    sudo tee "$APPLET_CONF" > /dev/null << EOF
{
    "menu-custom": { "type": "switch", "default": true },
    "menu-icon": { "type": "iconfilechooser", "default": "$ICON_PATH" },
    "menu-label": { "type": "entry", "default": "" }
}
EOF
fi

echo "Часть 1 завершена!"
