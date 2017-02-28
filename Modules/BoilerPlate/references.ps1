Get-ChildItem . -Recurse -Filter *.psm1 | 
	ForEach-Object { Import-Module -Name $_.FullName -Force }