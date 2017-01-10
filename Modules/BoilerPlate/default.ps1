. .\BoilerPlate.ps1
properties {
    $ModuleName = "BoilerPlate"
    $BaseDir = $psake.build_script_dir
    $OutDir = (Join-Path -Path $BaseDir -ChildPath "bin")
    $Version = '0.1.0' #Semantic Versioning 2.0.0 Major.Minor.Patch.Build
    $NugetExe = (Join-Path -Path $BaseDir -ChildPath "..\..\.nuget\nuget.exe")
}

Task Build -depends Test, Package
Task Package -depends Version-Module, Pack-Nuget, Unversion-Module
Task Release -depends Build, Push-Nuget

Task Clean {
	if(Test-Path -Path $OutDir){ Remove-Item -Path $OutDir -Recurse }
}

Task Test -depends PowerShellLint {
	Get-ChildItem -Path (Join-Path -Path $BaseDir -ChildPath "Functions") -Recurse | 
	Where-Object { -not ((Split-Path -Path $_ -Leaf).Contains(".Tests.")) } | 
	Where-Object { $null -eq (Get-Verb -verb ($_.BaseName.Split('-')[0]) -ErrorAction SilentlyContinue)} | 
	ForEach-Object { Write-Warning "Use of unknown verb detected for $($_.FullName)"}
	
	if(!(Test-Path -Path $OutDir)){ New-Item -Path $OutDir -ItemType Directory }
	if(!(Test-Path -Path $OutDir)){ mkdir $OutDir }
    Push-Location -Path "$BaseDir"
	exec { . "$BaseDir\Pester.cmd" }
    Pop-Location
}

Task PowerShellLint -alias lint {
	Invoke-ScriptAnalyzer -Path $BaseDir -Recurse
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
	Write-Warning "Not Implemented ... yet"
#    $pkg = Get-Item -path $OutDir\$ModuleName.$Version.nupkg
#    exec { .$NugetExe push $pkg.FullName }
}
