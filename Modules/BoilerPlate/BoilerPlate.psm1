#   Version: $version$
# Changeset: $sha$

Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "Functions") -Recurse | 
	? { -not ((Split-Path -Path $_ -Leaf).Contains(".Tests.")) } | 
	% { . $_.FullName; Export-ModuleMember -Function $_.BaseName }
	
