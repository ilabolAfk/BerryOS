#!/bin/bash
# ============================================================
# Berry OS — Часть 3: Berry Command Center (PyQt6)
# ============================================================

set -e
BIN_DIR="/usr/local/bin/berry-center"
APP_FILE="$BIN_DIR/main.py"
DESKTOP_FILE="/usr/share/applications/berry-center.desktop"
ICON_PATH="/usr/share/icons/hicolor/256x256/apps/berry-logo.png"

echo "[1/3] Установка зависимостей..."
sudo apt update
sudo apt install -y python3-pyqt6 python3-psutil
pip3 install qt-material --break-system-packages || echo "qt-material не установлен, будет стандартный стиль."

echo "[2/3] Создание приложения..."
sudo mkdir -p "$BIN_DIR"

# Пишем код Python (сокращенная версия из предыдущих шагов с App Store и Настройками)
sudo tee "$APP_FILE" > /dev/null << 'EOF'
import sys, os, subprocess, psutil
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                             QPushButton, QLabel, QTextEdit, QTabWidget, 
                             QMessageBox, QGridLayout, QScrollArea, QComboBox)
from PyQt6.QtCore import QTimer
from PyQt6.QtGui import QFont, QIcon

class BerryCenter(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Berry Command Center")
        self.setGeometry(100, 100, 800, 600)
        self.setWindowIcon(QIcon("/usr/share/icons/hicolor/256x256/apps/berry-logo.png"))
        self.tabs = QTabWidget()
        self.setCentralWidget(self.tabs)
        
        self.init_dashboard()
        self.init_app_store()
        self.init_settings()
        self.init_doctor()
        
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_stats)
        self.timer.start(1000)

    def init_dashboard(self):
        tab = QWidget(); layout = QVBoxLayout()
        layout.addWidget(QLabel("Добро пожаловать в Berry OS!"))
        self.lbl_cpu = QLabel("CPU: 0%"); self.lbl_ram = QLabel("RAM: 0%")
        layout.addWidget(self.lbl_cpu); layout.addWidget(self.lbl_ram)
        btn = QPushButton("Обновить систему")
        btn.clicked.connect(lambda: subprocess.Popen(["x-terminal-emulator", "-e", "berry-update"]))
        layout.addWidget(btn); layout.addStretch()
        tab.setLayout(layout); self.tabs.addTab(tab, "Главная")

    def init_app_store(self):
        tab = QWidget(); layout = QVBoxLayout()
        scroll = QScrollArea(); scroll.setWidgetResizable(True)
        content = QWidget(); grid = QGridLayout()
        apps = [("Chromium", "chromium", "Браузер"), ("Telegram", "telegram-desktop", "Мессенджер"),
                ("VLC", "vlc", "Видео"), ("Steam", "steam-installer", "Игры")]
        row, col = 0, 0
        for name, pkg, desc in apps:
            card = QWidget(); card.setStyleSheet("border: 1px solid #ccc; border-radius: 5px; padding: 10px;")
            cl = QVBoxLayout()
            cl.addWidget(QLabel(f"<b>{name}</b><br>{desc}"))
            b = QPushButton("Установить")
            b.clicked.connect(lambda checked, p=pkg: subprocess.Popen(["x-terminal-emulator", "-e", f"sudo apt install -y {p}"]))
            cl.addWidget(b); card.setLayout(cl)
            grid.addWidget(card, row, col)
            col += 1
            if col > 1: col = 0; row += 1
        content.setLayout(grid); scroll.setWidget(content); layout.addWidget(scroll)
        tab.setLayout(layout); self.tabs.addTab(tab, "App Store")

    def init_settings(self):
        tab = QWidget(); layout = QVBoxLayout()
        btn_codecs = QPushButton("Установить кодеки (мультимедиа)")
        btn_codecs.clicked.connect(lambda: subprocess.Popen(["x-terminal-emulator", "-e", "sudo apt install -y ubuntu-restricted-extras"]))
        layout.addWidget(btn_codecs)
        layout.addWidget(QLabel("Язык:")); cb = QComboBox(); cb.addItems(["Русский", "English"]); layout.addWidget(cb)
        layout.addStretch(); tab.setLayout(layout); self.tabs.addTab(tab, "Настройки")

    def init_doctor(self):
        tab = QWidget(); layout = QVBoxLayout()
        self.out = QTextEdit(); self.out.setStyleSheet("background: #1e1e1e; color: #0f0;")
        btn = QPushButton("Запустить Doctor")
        btn.clicked.connect(self.run_doc)
        layout.addWidget(btn); layout.addWidget(self.out)
        tab.setLayout(layout); self.tabs.addTab(tab, "Doctor")

    def update_stats(self):
        self.lbl_cpu.setText(f"CPU: {psutil.cpu_percent()}%")
        self.lbl_ram.setText(f"RAM: {psutil.virtual_memory().percent}%")

    def run_doc(self):
        self.out.clear(); self.out.append("Диагностика...")
        p = subprocess.Popen(["berry-doctor"], stdout=subprocess.PIPE, text=True)
        out, _ = p.communicate(); self.out.append(out)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    try:
        from qt_material import apply_stylesheet
        apply_stylesheet(app, theme='light_teal.xml')
    except ImportError: pass
    window = BerryCenter(); window.show(); sys.exit(app.exec())
EOF

sudo chmod +x "$APP_FILE"

echo "[3/3] Создание ярлыка..."
sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Type=Application
Name=Berry Command Center
Comment=Центр управления Berry OS
Exec=python3 $APP_FILE
Icon=$ICON_PATH
Terminal=false
Categories=System;
EOF

mkdir -p /etc/skel/Desktop
cp "$DESKTOP_FILE" /etc/skel/Desktop/berry-center.desktop
chmod +x /etc/skel/Desktop/berry-center.desktop

echo "Часть 3 завершена! Berry OS готова к сборке."
