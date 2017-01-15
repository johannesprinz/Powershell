Include ".\BoilerPlate.ps1"

properties {
    $ModuleName = "BoilerPlate"
    $BaseDir = $psake.build_script_dir
    $OutDir = (Join-Path -Path $BaseDir -ChildPath "bin")
    $Version = '0.1.0' #Semantic Versioning 2.0.0 Major.Minor.Patch.Build
    $NugetExe = (Join-Path -Path $BaseDir -ChildPath "..\..\.nuget\nuget.exe")
	$message = @{
		notImplemented = 'This task has not been implemented yet'
	}
}

Task Build -depends Test, Package
Task Package -depends Version-Module, Pack-Nuget, Unversion-Module
Task Release -depends Build, Push-Nuget

Task Clean {
	if(Test-Path -Path $OutDir){ Remove-Item -Path $OutDir -Recurse }
}

Task Test {
	Invoke-ScriptAnalyzer -Path $BaseDir -Recurse
	if(!(Test-Path -Path $OutDir)){ New-Item -Path $OutDir -ItemType Directory }
	Push-Location -Path "$BaseDir"
	exec { . "$BaseDir\Pester.cmd" }
    Pop-Location
}

Task Version-Module{
    $changeset=(git log -1 --pretty=tformat:%h)
	$build=(git rev-list --count HEAD)
	(Get-Content "$BaseDir\$ModuleName.psm1") `
      | ForEach-Object {$_ -replace "\`$version\`$", [string]::Format("{0}.{1}", $Version, $build) } `
      | ForEach-Object {$_ -replace "\`$sha\`$", "$changeset" } `
      | Set-Content "$BaseDir\$ModuleName.psm1"
}

Task Unversion-Module{
    $changeset=(git log -1 --pretty=tformat:%h)
	$build=(git rev-list --count HEAD)
    (Get-Content "$BaseDir\$ModuleName.psm1") `
      | ForEach-Object {$_ -replace [string]::Format("{0}.{1}", $Version, $build), "`$version`$" } `
      | ForEach-Object {$_ -replace "$changeset", "`$sha`$" } `
      | Set-Content "$BaseDir\$ModuleName.psm1"
}

Task Pack-Nuget {
	if(!(Test-Path -Path $OutDir)){ New-Item -Path $OutDir -ItemType Directory }
	$build=(git rev-list --count HEAD)
    exec { . $NugetExe pack "$BaseDir\$ModuleName.nuspec" -OutputDirectory "$OutDir" -NoPackageAnalysis -version ([string]::Format("{0}.{1}", $Version, $build)) }
}

Task Push-Nuget {
	Write-Warning -Message $message.notImplemented;
#    $pkg = Get-Item -path $OutDir\$ModuleName.$Version.nupkg
#    exec { .$NugetExe push $pkg.FullName }
}
