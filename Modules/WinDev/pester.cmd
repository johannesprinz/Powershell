@echo off
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -NoProfile -Command "Import-Module Pester; & { Invoke-Pester -OutputFile 'bin\Test.xml' -OutputFormat LegacyNUnitXml -EnableExit %ARGS%};"
goto :eof
