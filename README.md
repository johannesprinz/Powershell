Powershell
==========
My collection of usefull Powershell modules

####Modules
All modules stem from my Boilerplate module and use [psake](https://github.com/psake/psake), [Pester](https://github.com/pester/Pester), [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) and [PowershellGet](https://www.powershellgallery.com/). 
######Boilerplate
This module I use to stub out new powershell modules. It sets up the new project structure for the powershell module including automated build scripts, testing frameworks and nuget packaging functions.

To use:

1. ~~Make the required edits to Modules\BoilerPlate\BoilerPlate.nuspec if you're considering using  [nuget](https://www.nuget.org/) and/or [PsGet](http://psget.net/).~~ **Note:**
  * You will need to use your own NuGet.exe if you'd like to publish the package
  * **Upcoming changes** will be made to work with **[PowershellGet](https://www.powershellgallery.com/)** instead of ~~nuget~~
2. Run Build-Dependencies.ps1 to install the dependecies mentioned above
3. Launch Modules\BoilerPlate\here.cmd `Invoke-psake Make-Module`
4. Enter the name of the new module
5. Launch Modules\MyNewModule\here.cmd `Invoke-psake Build`
6. Checkout the new nuget package in Modules\MyNewModule\bin which is also where the test results are logged.
7. Thats it now edit and add to the functions in the Modules\MyNewModule\Functions directory and remeber to write tests.

The sample Format-HelloWorld.ps1 function is now my personal template for all functions going ahead.
Hope this give you value.
**Happy days**
