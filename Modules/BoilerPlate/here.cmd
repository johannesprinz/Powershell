@echo off
powershell -NoLogo -NoExit -ExecutionPolicy Bypass -Command "& '%~dp0\..\..\packages\psake.4.3.2\tools\psake.ps1' -docs %*;"
