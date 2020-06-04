# Autounstall
Skript für die automatische Installation

### Der Inhalt:

[XML ](*)

[Script](*)

[Starter](*)

Die .xml-Datei ist ein Handbuch für die automatische Installation, sie enthält Informationen über Programme, die installiert werden müssen, Dateien, die kopiert werden müssen.
## Info

Enthält grundlegende Informationen und eine Datei.

- ***name*** - Klarer und verständlicher Name, er wird in ein Log geschrieben.
- ***dependence*** - Abhängigkeiten, Link zu einem anderen für diese Installation erforderlichen Xml. Es wird zuerst installiert.
- ***date*** - Datum, an dem die Datei erstellt wurde.
- ***author*** - Autor.
- ***stepscount*** - Anzahl der Schritte
- ***reboot*** - ob Rechner neue gestarten muss

## Step

Enthält Anweisungen für einen einzelnen Schritt, die Installation des Programms, das Kopieren des Ordners oder die Erstellung eines neuen Ordners.

- ***name*** - Name für diesen Schritt, er wird in Log gespeichert und während der Installation angezeigt.
- ***option*** - Die gewählte Option, was zu tun ist.
- ***path*** - Pfad zum installierten Programm, Ordner, in dem der Ordner angelegt/kopiert werden soll.
- ***prams*** - Zusätzliche Parameter für die Software-Installation.
- ***folder_name*** - Name für neu erstellten Ordner.
- **dest_path** - Pfad zum Zielordner.

## Option

- ***install*** - Installieren des Programms
    - benötigt path
    - optional parms
- ***create_folder*** - erstellt einen neuen Ordner
    - benötigt path
    - benötigt folder name
- ***copy_folder*** - Kopieren den Ordner
    - benötigt path
    - benötigt dest_path
- script - Startet das .bat-Skript
    - benötigt path

## Variable

Variablen, die zum Erstellen oder Kopieren von Dateien und/oder Ordnern verwendet werden.

- **%FAV%** - *C:\Users\USER\Favorites*
- **%DESKTOP%** -  *C:\Users\USER\Desktop*
- **%DOCU%** - *C:\Users\USER\Documents*
- **%APPDATA%** - *C:\Users\USER\AppData\Roaming*
- **%ProgramFiles%** - *C:\Program Files*


### Script
Es liest die Daten aus der xml-Datei und folgt den darin enthaltenen Anweisungen.

## Parameter

- **-XML** - Ort der xml-Datei
- **-Cleanup** - Mit dieser Option das Skript reinigt die Registrierung nach Abschluss der Arbeit und kopiert die Protokolldateien in den richtigen Ordner.
- **-IgnoreDependence** - das Skript ignoriert die Abhängigkeiten von Xml-Dateien

### Kompilation

**ACHTUNG Beim Kompilieren muss das Skript den Namen "autoinstall.exe" erhalten!!!**

### Starter
Das Skript, mit dem die automatische Installation ausgeführt wird
