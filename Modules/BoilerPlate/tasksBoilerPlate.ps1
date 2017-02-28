properties {
    $baseDir = $psake.build_script_dir
}

Task Make-Module -Depends Clean {
	$moduleName = Read-Host -Prompt "Name of new module";
	$targetPath = Join-Path -Path $baseDir -ChildPath "..\$moduleName";
	if(Test-Path $targetPath) { Write-Error "Module $moduleName already exists!"; return; }
	
	Copy-Item -Path $baseDir -Destination $targetPath -Recurse
	Remove-Item -Path $targetPath -Filter *BoilerPlate* -Recurse -ErrorAction SilentlyContinue
	Copy-Item -Path "$baseDir\BoilerPlate.psm1" -Destination "$targetPath\$moduleName.psm1";
	Get-Content -Path "$baseDir\default.ps1" | ForEach-Object{$_.Replace('Include ".\tasksBoilerPlate.ps1"',"").Replace("BoilerPlate",$moduleName)} | Out-File -FilePath "$targetPath\default.ps1" -Encoding UTF8 	
	Get-Content -Path "$baseDir\BoilerPlate.nuspec" | ForEach-Object{$_.Replace("BoilerPlate",$moduleName)} | Out-File -FilePath "$targetPath\$moduleName.nuspec" -Encoding UTF8 	
}