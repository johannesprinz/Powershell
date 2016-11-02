# Version: 0.1.0
# Changeset: 
Add-PSSnapin -Name Microsoft.TeamFoundation.PowerShell;
Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "Functions") -Recurse | 
	Where-Object { -not ((Split-Path -Path $_ -Leaf).Contains(".Tests.")) } | 
	ForEach-Object { . $_.FullName; Export-ModuleMember -Function $_.BaseName }
	
