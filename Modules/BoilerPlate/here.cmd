@echo off
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -Command "& Import-Module psake; Invoke-psake -docs %*;"
