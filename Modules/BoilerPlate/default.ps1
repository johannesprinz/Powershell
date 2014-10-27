. .\BoilerPlate.ps1
properties {
	$ModuleName = "BoilerPlate"
    $BaseDir = $psake.build_script_dir
    $OutDir = (Join-Path -Path $BaseDir -ChildPath "bin")
    $Version = '0.1.0' #Semantic Versioning 2.0.0 Major.Minor.Patch
    $NugetExe = (Join-Path -Path $BaseDir -ChildPath "..\.nuget\nuget.exe")
}

Task Build -depends Test, Package
Task Package -depends Version-Module, Pack-Nuget, Unversion-Module
Task Release -depends Build, Push-Nuget

Task Clean {
	if(Test-Path -Path $OutDir){ Remove-Item -Path $OutDir -Recurse }
}

Task Test {
	Get-ChildItem -Path (Join-Path -Path $BaseDir -ChildPath "Functions") -Recurse | 
	? { -not ((Split-Path -Path $_ -Leaf).Contains(".Tests.")) } | 
	? { $null -eq (Get-Verb -verb ($_.BaseName.Split('-')[0]) -ErrorAction SilentlyContinue)} | 
	% { Write-Warning "Use of unknown verb detected for $($_.FullName)"}
	
	if(!(Test-Path -Path $OutDir)){ mkdir $OutDir }
    pushd "$BaseDir"
	exec { . "$BaseDir\Pester.cmd" }
    popd
}

Task Version-Module{
    $changeset=(hg log -r . --template '{node|short}')
    (Get-Content "$BaseDir\$ModuleName.psm1") `
      | % {$_ -replace "\`$version\`$", "$Version" } `
      | % {$_ -replace "\`$sha\`$", "$changeset" } `
      | Set-Content "$BaseDir\$ModuleName.psm1"
}

Task Unversion-Module{
    $changeset=(hg log -r . --template '{node|short}')
    (Get-Content "$BaseDir\$ModuleName.psm1") `
      | % {$_ -replace "$Version", "`$version`$" } `
      | % {$_ -replace "$changeset", "`$sha`$" } `
      | Set-Content "$BaseDir\$ModuleName.psm1"
}

Task Pack-Nuget {
	if(!(Test-Path -Path $OutDir)){ mkdir $OutDir }
    exec { . $NugetExe pack "$BaseDir\$ModuleName.nuspec" -OutputDirectory "$OutDir" -NoPackageAnalysis -version $Version }
}

Task Push-Nuget {
	Write-Warning "Not Implemented ... yet"
#    $pkg = Get-Item -path $OutDir\$ModuleName.$Version.nupkg
#    exec { .$NugetExe push $pkg.FullName }
}
