Powershell
==========
My collection of usefull Powershell modules

####Modules
All modules stem from my Boilerplate module and use [nuget](https://www.nuget.org/), [psake](https://github.com/psake/psake) and [Pester](https://github.com/pester/Pester). 
######Boilerplate
This module I use to stub out new powershell modules. It sets up the new project structure for the powershell module including automated build scripts, testing frameworks and nuget packaging functions.

To use:

1. Make the required edits to Modules\BoilerPlate\BoilerPlate.nuspec if you're considering using  [nuget](https://www.nuget.org/) and/or [PsGet](http://psget.net/)
2. Launch Modules\BoilerPlate\here.cmd `Invoke-psake Make-Module`
3. Enter the name of the new module
4. Launch Modules\MyNewModule\here.cmd `Invoke-psake Build`
5. Checkout the new nuget package in Modules\MyNewModule\bin which is also where the test results are logged.
6. Thats it now edit and add to the functions in the Modules\MyNewModule\Functions directory and remeber to write tests.
