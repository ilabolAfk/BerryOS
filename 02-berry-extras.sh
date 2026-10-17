#!/bin/bash
# ============================================================
# Berry OS — Часть 2: Экстра-команды и MOTD
# ============================================================

set -e
BIN="/usr/local/bin"

echo "[1/3] Создание Berry Extras..."

sudo tee "$BIN/berry-extract" > /dev/null << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then echo "Использование: berry-extract <файл>"; exit 1; fi
case "$1" in
    *.tar.bz2) tar xjf "$1" ;; *.tar.gz) tar xzf "$1" ;; *.tar.xz) tar xJf "$1" ;;
    *.bz2) bunzip2 "$1" ;; *.rar) unrar x "$1" ;; *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;; *.tbz2) tar xjf "$1" ;; *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;; *.7z) 7z x "$1" ;; *) echo "Неизвестный формат" ;;
esac
EOF

sudo tee "$BIN/berry-fetch" > /dev/null << 'EOF'
#!/bin/bash
GREEN='\033[1;32m'; CYAN='\033[1;36m'; NC='\033[0m'
echo -e "${GREEN}      .---.      ${NC}"
echo -e "${GREEN}     /     \     ${NC}  ${CYAN}$(whoami)@$(hostname)${NC}"
echo -e "${GREEN}    | () () |    ${NC}  OS: Berry OS $(cat /etc/berry-version)"
echo -e "${GREEN}     \  ^  /     ${NC}  Kernel: $(uname -r)"
echo -e "${GREEN}      |||||      ${NC}  CPU: $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')"
echo -e "${GREEN}      '---'      ${NC}"
EOF

sudo tee "$BIN/berry-sysinfo" > /dev/null << 'EOF'
#!/bin/bash
echo "=== Материнская плата ==="; sudo dmidecode -t baseboard | grep -E "Manufacturer|Product Name"
echo -e "\n=== Процессор ==="; lscpu | grep -E "Model name|Architecture|CPU\(s\):"
echo -e "\n=== Память ==="; sudo dmidecode -t memory | grep -E "Size|Speed" | grep -v "No Module"
echo -e "\n=== Видео ==="; lspci | grep -i vga
echo -e "\n=== Диски ==="; lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
EOF

sudo chmod +x "$BIN"/berry-*

echo "[2/3] Настройка MOTD (приветствие в терминале)..."
sudo tee /etc/update-motd.d/99-berry-welcome > /dev/null << 'EOF'
#!/bin/bash
GREEN='\033[1;32m'; CYAN='\033[1;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo ""
echo -e "${GREEN}Добро пожаловать в Berry OS${NC}"
echo -e "${CYAN}Мощная операционная система${NC}"
echo ""
echo -e "${YELLOW}Ядро:${NC} $(uname -r) | ${YELLOW}Аптайм:${NC} $(uptime -p | sed 's/up //')"
echo -e "${YELLOW}CPU:${NC} $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.0f", 100 - $1}')% | ${YELLOW}RAM:${NC} $(free -h | awk '/^Mem:/ {print $3}') / $(free -h | awk '/^Mem:/ {print $2}')"
echo ""
EOF
sudo chmod +x /etc/update-motd.d/99-berry-welcome

echo "[3/3] Обновление алиасов..."
sudo tee -a /etc/profile.d/berry-aliases.sh > /dev/null << 'EOF'
alias extract='berry-extract'
alias fetch='berry-fetch'
alias hwinfo='berry-sysinfo'
EOF

echo "Часть 2 завершена!"
