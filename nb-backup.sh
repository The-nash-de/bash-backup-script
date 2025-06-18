#!/bin/bash

# ---------------------------------------------
# Vollständiges System-Backup mit rsync & tar
# Erstellt ein vollständiges Backup des Systems
# und komprimiert es als .tar.gz-Archiv.
# ---------------------------------------------

# --- WICHTIG ---
# Dieses Skript sollte mit sudo ausgeführt werden, da root-Rechte für einige Verzeichnisse notwendig sind.

# --- Erklärung zu ausgeschlossenen Verzeichnissen ---
# /dev     → Virtuelle Geräte, nicht sinnvoll zu sichern
# /proc    → Laufzeitinformationen des Kernels (virtuell)
# /sys     → Informationen über Systemgeräte (virtuell)
# /tmp     → Temporäre Dateien
# /run     → Temporäre Laufzeitdaten (z. B. PID-Dateien)
# /mnt     → Temporäre Mountpoints
# /media   → Wechselmedien (USB etc.)
# /lost+found → Dateisystemwiederherstellung (nicht relevant)
# BACKUP_DIR → Der Backup-Ordner selbst wird ausgeschlossen, um Endlosschleifen zu verhindern

# --- Benutzerabhängiger Pfad (nicht /root) ---
USER_HOME=$(eval echo "~$SUDO_USER")
BACKUP_DIR="$USER_HOME/server-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
WORK_DIR="$BACKUP_DIR/work-$TIMESTAMP"
ARCHIVE_PATH="$BACKUP_DIR/full-backup-$TIMESTAMP.tar.gz"

# --- Vorbereitung ---
echo "[*] Backup-Ziel: $ARCHIVE_PATH"
mkdir -p "$WORK_DIR"
if [ $? -ne 0 ]; then
    echo "[!] Fehler beim Erstellen des Arbeitsverzeichnisses: $WORK_DIR"
    exit 1
fi

# --- Backup durchführen ---
echo "[*] Starte rsync..."
rsync -aAXv / "$WORK_DIR" \
  --exclude=/dev \
  --exclude=/proc \
  --exclude=/sys \
  --exclude=/tmp \
  --exclude=/run \
  --exclude=/mnt \
  --exclude=/media \
  --exclude=/lost+found \
  --exclude="$BACKUP_DIR"

if [ $? -ne 0 ]; then
    echo "[!] Fehler beim rsync-Vorgang."
    exit 2
fi

# --- Archiv erstellen ---
echo "[*] Erstelle komprimiertes Archiv..."
tar -czpf "$ARCHIVE_PATH" -C "$WORK_DIR" .
if [ $? -ne 0 ]; then
    echo "[!] Fehler beim Erstellen des Archivs."
    exit 3
fi

# --- Aufräumen ---
echo "[*] Entferne temporäres Arbeitsverzeichnis..."
rm -rf "$WORK_DIR"

# --- Erfolgsmeldung ---
ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
echo "[*] Backup erfolgreich abgeschlossen."
echo "     Datei: $ARCHIVE_PATH"
echo "     Größe: $ARCHIVE_SIZE"
