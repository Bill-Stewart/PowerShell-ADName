#define ModuleName "ADName"
#define AppName ModuleName + " PowerShell Module"
#define AppPublisher "Bill Stewart"
#define AppVersion "1.1"
#define InstallPath "WindowsPowerShell\Modules\" + ModuleName
#define IconFilename "ADName.ico"
#define SetupCompany "Bill Stewart (bstewart@iname.com)"
#define SetupVersion "1.1.0.0"

[Setup]
AppId={{5CEBB991-E234-45E6-A3DD-9A57CFDFBC0E}
AppName={#AppName}
AppPublisher={#AppPublisher}
AppVersion={#AppVersion}
ArchitecturesInstallIn64BitMode=x64
Compression=lzma2/max
DefaultDirName={code:GetInstallDir}
DisableDirPage=yes
MinVersion=6.1
OutputBaseFilename={#ModuleName}_{#AppVersion}_Setup
OutputDir=.
PrivilegesRequired=admin
SetupIconFile={#IconFilename}
SolidCompression=yes
UninstallDisplayIcon={code:GetInstallDir}\{#IconFilename}
UninstallFilesDir={code:GetInstallDir}\Uninstall
VersionInfoCompany={#SetupCompany}
VersionInfoProductVersion={#AppVersion}
VersionInfoVersion={#SetupVersion}
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardResizable=no
WizardSizePercent=150
WizardSmallImageFile={#ModuleName}_55x55.bmp
WizardStyle=modern

[Languages]
Name: english; InfoBeforeFile: "Readme.rtf"; LicenseFile: "License.rtf"; MessagesFile: "compiler:Default.isl"

[Files]
; 32-bit
Source: "{#IconFilename}";    DestDir: "{commonpf32}\{#InstallPath}"; Check: not Is64BitInstallMode
Source: "License.txt";        DestDir: "{commonpf32}\{#InstallPath}"
Source: "Readme.md";          DestDir: "{commonpf32}\{#InstallPath}"
Source: "{#ModuleName}.psd1"; DestDir: "{commonpf32}\{#InstallPath}"
Source: "{#ModuleName}.psm1"; DestDir: "{commonpf32}\{#InstallPath}"
; 64-bit
Source: "{#IconFilename}";    DestDir: "{commonpf64}\{#InstallPath}"; Check: Is64BitInstallMode
Source: "License.txt";        DestDir: "{commonpf64}\{#InstallPath}"; Check: Is64BitInstallMode
Source: "Readme.md";          DestDir: "{commonpf64}\{#InstallPath}"; Check: Is64BitInstallMode
Source: "{#ModuleName}.psd1"; DestDir: "{commonpf64}\{#InstallPath}"; Check: Is64BitInstallMode
Source: "{#ModuleName}.psm1"; DestDir: "{commonpf64}\{#InstallPath}"; Check: Is64BitInstallMode

[Code]
function GetWindowsPowerShellMajorVersion(): integer;
  var
    RootPath,VersionString: string;
    SubkeyNames: TArrayOfString;
    HighestPSVersion,I,PSVersion: integer;
  begin
  result := 0;
  RootPath := 'SOFTWARE\Microsoft\PowerShell';
  if not RegGetSubkeyNames(HKEY_LOCAL_MACHINE,RootPath,SubkeyNames) then
    exit;
  HighestPSVersion := 0;
  for I := 0 to GetArrayLength(SubkeyNames) - 1 do
    begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE,RootPath + '\' + SubkeyNames[I] + '\PowerShellEngine','PowerShellVersion',VersionString) then
      begin
      PSVersion := StrToIntDef(Copy(VersionString,0,1),0);
      if PSVersion > HighestPSVersion then
        HighestPSVersion := PSVersion;
      end;
    end;
  result := HighestPSVersion;
  end;

Function InitializeSetup(): boolean;
  var
    PSMajorVersion: integer;
  begin
  PSMajorVersion := GetWindowsPowerShellMajorVersion();
  result := PSMajorVersion >= 3;
  if not result then
    begin
    Log('FATAL: Setup cannot continue because Windows PowerShell version 3.0 or later is required.');
    if not WizardSilent() then
      begin
      MsgBox('Setup cannot continue because Windows PowerShell version 3.0 or later is required.'
        + #13#10#13#10 + 'Setup will now exit.',mbCriticalError,MB_OK);
      end;
    exit;
    end;
  Log('Windows PowerShell major version ' + IntToStr(PSMajorVersion) + ' detected');
  end;

function GetInstallDir(Param: string): string;
  begin
  if Is64BitInstallMode() then
    result := ExpandConstant('{commonpf64}\{#InstallPath}')
  else
    result := ExpandConstant('{commonpf32}\{#InstallPath}');
  end;
