@echo off
"..\..\.nuget\NuGet.exe" restore -PackagesDirectory "..\..\packages"
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -Command "& Import-Module '%~dp0\..\..\packages\Pester.3.1\tools\Pester.psm1'; & { Invoke-Pester -OutputFile 'bin\Test.xml' -OutputFormat LegacyNUnitXml -EnableExit %ARGS%}"
