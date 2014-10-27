@echo off
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -Command "& Import-Module '%~dp0\..\Pester\Pester.psm1'; & { Invoke-Pester -OutputXml 'bin\Test.xml' -EnableExit %ARGS%}"
