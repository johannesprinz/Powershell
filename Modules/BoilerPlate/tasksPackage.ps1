Include ".\references.ps1"

properties {
    $moduleName = "BoilerPlate"
    $version = '0.1.0' #Semantic Versioning 2.0.0 Major.Minor.Patch.Build
	$dir = @{
		base =(Get-Item -Path $psake.build_script_dir).FullName;
		bin = (Join-Path -Path $psake.build_script_dir -ChildPath "bin");
	}
	$tool = @{
		nuget = (Join-Path -Path $dir.base -ChildPath "..\..\.nuget\nuget.exe")
	}
    $NugetExe = (Join-Path -Path $BaseDir -ChildPath "..\..\.nuget\nuget.exe")
}

Task Default -Depends Version-Module, Pack-Nuget, Unversion-Module

Task Version-Module{
    $changeset=(git log -1 --pretty=tformat:%h)
	$build=(git rev-list --count HEAD)
	(Get-Content "$($dir.base)\$moduleName.psm1") `
      | ForEach-Object {$_ -replace "\`$version\`$", [string]::Format("{0}.{1}", $version, $build) } `
      | ForEach-Object {$_ -replace "\`$sha\`$", "$changeset" } `
      | Set-Content "$($dir.base)\$moduleName.psm1"
}

Task Unversion-Module{
    $changeset=(git log -1 --pretty=tformat:%h)
	$build=(git rev-list --count HEAD)
    (Get-Content "$($dir.base)\$moduleName.psm1") `
      | ForEach-Object {$_ -replace [string]::Format("{0}.{1}", $version, $build), "`$version`$" } `
      | ForEach-Object {$_ -replace "$changeset", "`$sha`$" } `
      | Set-Content "$($dir.base)\$moduleName.psm1"
}

Task Pack-Nuget {
	if(!(Test-Path -Path $dir.bin)){ New-Item -Path $dir.bin -ItemType Directory }
	$build=(git rev-list --count HEAD)
    #exec { . $tool.nuget pack "$($dir.base)\$moduleName.nuspec" -OutputDirectory $dir.bin -NoPackageAnalysis -Version ([string]::Format("{0}.{1}", $version, $build)) }
}
