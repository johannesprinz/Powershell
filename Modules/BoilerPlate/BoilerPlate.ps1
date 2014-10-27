properties {
    $baseDir = $psake.build_script_dir
}

Task Make-Module{
	$moduleName = Read-Host -Prompt "Name of new module";
	$targetPath = Join-Path -Path $baseDir -ChildPath "..\$moduleName";
	if(Test-Path $targetPath) { Write-Host "Module $moduleName already exists!" -ForegroundColor Red; return; }
	
	Copy-Item -Path "$baseDir\Functions" -Recurse -Destination "$targetPath\Functions";
	Copy-Item -Path "$baseDir\*.cmd" -Destination $targetPath;
	Copy-Item -Path "$baseDir\BoilerPlate.psm1" -Destination "$targetPath\$moduleName.psm1";
	Get-Content -Path "$baseDir\default.ps1" | %{$_.Replace(". .\BoilerPlate.ps1","").Replace("BoilerPlate",$moduleName)} | Out-File -FilePath "$targetPath\default.ps1" -Encoding UTF8 	
	Get-Content -Path "$baseDir\BoilerPlate.nuspec" | %{$_.Replace(". .\boilerplate.ps1","").Replace("BoilerPlate",$moduleName)} | Out-File -FilePath "$targetPath\$moduleName.nuspec" -Encoding UTF8 	
}
