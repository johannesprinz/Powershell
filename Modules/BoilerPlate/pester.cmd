@echo off
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -Command "& Import-Module '%~dp0\..\packages\Pester.3.1\tools\Pester.psm1'; & { Invoke-Pester -OutputXml 'bin\Test.xml' -EnableExit %ARGS%}"
