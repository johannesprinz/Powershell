Include ".\references.ps1"

properties {
	$dir = @{
		base =(Get-Item -Path $psake.build_script_dir).FullName;
		bin = (Join-Path -Path $psake.build_script_dir -ChildPath "bin")
	}
}

Task Default -Depends Test-PowerShell

Task Test-PowerShell {
	$resultXml = Join-Path -Path $dir.base -ChildPath 'bin\Test.xml';
	New-Item -Path (Split-Path -Path $resultXml -Parent) -ItemType Directory -Force | Out-Null;
	Invoke-Pester -OutputFile $resultXml -OutputFormat NUnitXml -Show Fails;
}

Task Clean {
	if(Test-Path -Path $dir.bin){ Remove-Item -Path $dir.bin -Recurse }
}