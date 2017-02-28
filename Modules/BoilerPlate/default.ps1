Include ".\tasksBoilerPlate.ps1"

properties {
    $moduleName = "BoilerPlate"
    $version = '0.1.0' #Semantic Versioning 2.0.0 Major.Minor.Patch.Build
	$dir = @{
		base =(Get-Item -Path $psake.build_script_dir).FullName;
		bin = (Join-Path -Path $psake.build_script_dir -ChildPath "bin");
	}
	$tool = @{
		nuget = (Join-Path -Path $dir.base -ChildPath "..\..\.nuget\nuget.exe");
	}
    $NugetExe = 
	$message = @{
		notImplemented = 'This task has not been implemented yet'
	}
}

Task Default -Depends Get-Help

Task Get-Help {
	if(Test-Path -Path ..\README.md) {
		Write-Verbose -Message "README can be found here .\README.md" -Verbose
	}
	Invoke-psake -docs -nologo
	Get-ChildItem -Path $dir.base -Filter task*.ps1 | Foreach-Object {
		Write-Verbose -Message $_.FullName -Verbose;
		Invoke-psake -buildFile $_ -docs -nologo;
	}
}

Task Setup -Description "Sets up your environment ready for development" {
	Write-Warning -Message "Please refere to $(Join-Path -Path $dir.src -ChildPath README.md)"
}

Task Clean {
	Invoke-psake -buildFile .\tasksTest.ps1 -nologo -taskList Clean
}

Task Build -Depends Clean {
    Invoke-ScriptAnalyzer -Path . -Recurse;
	Import-Module -Name .\$moduleName.psm1 -Force -Verbose
}

Task Test -Depends Build {
	Invoke-psake -buildFile .\tasksTest.ps1 -nologo
}

Task Package -Depends Test {
	Invoke-psake -buildFile .\tasksPackage.ps1 -nologo
}

Task Publish -Depends Package {
	Write-Warning -Message $message.notImplemented;
}

Task Deploy -Depends Publish {
	Write-Warning -Message $message.notImplemented;
#    $pkg = Get-Item -path "$($dir.bin)\$moduleName.$version.nupkg"
#    exec { . $tool.nuget push $pkg.FullName }
}