; Instalador de Hatchway — genera Hatchway-Windows-<version>-Setup.exe
; Requiere Inno Setup 6 (iscc.exe). Antes de compilar, corre:
;   flutter build windows --release --dart-define=API_URL=https://api.plicdreft.com
; desde desktop-app-flutter/, para que build\windows\x64\runner\Release exista.

#define MyAppName "Hatchway"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Plicdreft"
#define MyAppExeName "hatchway_desktop.exe"
#define SourceDir "..\build\windows\x64\runner\Release"

[Setup]
AppId={{0580AE30-5136-479C-8544-B1A84AE9D8ED}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
DisableDirPage=no
OutputDir=Output
OutputBaseFilename=Hatchway-Windows-{#MyAppVersion}-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "Crear un acceso directo en el Escritorio"; GroupDescription: "Accesos directos:"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Desinstalar {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Abrir {#MyAppName}"; Flags: nowait postinstall skipifsilent
