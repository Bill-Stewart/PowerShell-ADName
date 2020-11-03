@{
  RootModule        = 'ADName.psm1'
  ModuleVersion     = '1.1.0.0'
  GUID              = 'e25f1d1c-dd65-4e28-9236-47627fe1b635'
  Author            = 'Bill Stewart'
  CompanyName       = 'Bill Stewart'
  Copyright         = '(C) 2017-2020 by Bill Stewart'
  Description       = 'Implements the NameTranslate and Pathname COM objects as easy-to-use PowerShell functions.'
  PowerShellVersion = '3.0'
  AliasesToExport   = '*'
  FunctionsToExport = @(
    'Convert-ADName'
    'Get-ADName'
  )
}
