function Get-ProjectDependencies {
	[OutputType([String])]
    [CmdletBinding()]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ProjectFilePath
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$content = [XML](Get-Content $ProjectFilePath);
		$content.Project.ItemGroup.Compile | 
			Where-Object {
				$null -ne $_ 
			} | 
			ForEach-Object {
				Write-Output (Join-Path -Path (Split-Path -Path $ProjectFilePath -Parent) -ChildPath $_.Include);
			}
		$content.Project.ItemGroup.Content | 
			Where-Object {
				$null -ne $_ -and
				$null -ne $_.CopyToOutputDirectory -and 
				$_.CopyToOutputDirectory -ne 'Do not copy'
			} | 
			ForEach-Object {
				Write-Output (Join-Path -Path (Split-Path -Path $ProjectFilePath -Parent) -ChildPath $_.Include);
			}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}
