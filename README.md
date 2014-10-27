Powershell
==========
My collection of usefull Powershell modules

####Modules
All modules stem from my Boilerplate module and use [nuget](https://www.nuget.org/), [psake](https://github.com/psake/psake) and [Pester](https://github.com/pester/Pester). 
######Boilerplate
This module I use to stub out new powershell modules. It sets up the new project structure for the powershell module including automated build scripts, testing frameworks and nuget packaging functions.

To use:

1. Launch Modules\BoilerPlate\here.cmd `Invoke-psake Make-Module`
2. Enter the name of the new module
3. Launch Modules\MyNewModule\here.cmd `Invoke-psake Build`
4. Checkout the new nuget package in Modules\MyNewModule\bin which is also where the test results are logged.
