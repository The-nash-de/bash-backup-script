nb-backup.sh

Dieses Skript erstellt ein vollständiges Systembackup unter Linux mit Hilfe von rsync und speichert es als komprimiertes Archiv im Verzeichnis ~/server-backup.

Das Backup enthält alle wichtigen Verzeichnisse und Konfigurationsdateien. Bestimmte systeminterne Ordner wie /dev, /proc, /sys, /tmp, /run, /mnt, /media und /lost+found werden ausgeschlossen, da sie entweder dynamisch erstellt werden oder keine relevanten Daten enthalten.


Verwendung:

Backup erstellen:

Führen Sie das Skript mit Root-Rechten aus:

sudo ./nb-backup.sh

Das Backup wird automatisch im Verzeichnis ~/server-backup/ erstellt. Der Dateiname enthält Datum und Uhrzeit, zum Beispiel:

full-backup-2025-06-18_05-09-18.tar.gz


Backup vom Server auf das lokale System übertragen:

Da sich das Backup auf dem Server befindet, muss es mit scp auf das lokale System übertragen werden.

Das lässt sich leicht mit dem Tool SCP realisieren.

scp benutzername@serveradresse:/home/benutzername/server-backup/full-backup-2025-06-18_05-09-18.tar.gz C:/Users/dein-username/Desktop/



Backup wiederherstellen:

Anschließend kann das Backup wie folgt entpackt werden:

sudo tar -xvpf full-backup-2025-06-18_05-09-18.tar.gz -C /

Hinweis: Die Option -C / sorgt dafür, dass das Archiv direkt ins Wurzelverzeichnis entpackt wird. Dadurch werden vorhandene Dateien möglicherweise überschrieben. Bitte sei dir sicher, was du tust.

Voraussetzungen:

– Ein Linux-System
– Die Programme bash, rsync und tar
– Root-Rechte (z. B. durch sudo)
– Zugriff auf das Archiv (bei Wiederherstellung z. B. über scp)

Lizenz:

Dieses Projekt steht unter der MIT-Lizenz. Details siehe Datei LICENSE.
