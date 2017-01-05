function Test-ProjectBuildRequired {
	[OutputType([Boolean])]
    [CmdletBinding(
    )]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ProjectFilePath,
		[Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Configuration='Debug'
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
		$latestDependency= Get-ProjectDependencies -ProjectFilePath $ProjectFilePath | 
			Get-Item | 
			Sort-Object LastWriteTime -Descending | 
			Select-Object -First 1
		$latestOutput = Get-ProjectOutputs -ProjectFilePath $ProjectFilePath -Configuration $Configuration | 
			Get-Item | 
			Sort-Object LastWriteTime -Descending | 
			Select-Object -First 1
		return $latestDependency.LastWriteTime -gt $latestOutput.LastWriteTime;
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}
