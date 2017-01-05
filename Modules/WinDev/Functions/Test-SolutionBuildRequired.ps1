function Test-SolutionBuildRequired {
	[OutputType([Boolean])]
    [CmdletBinding(
    )]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$SolutionFilePath,
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
		Get-Projects -SolutionFilePath $SolutionFilePath | 
			ForEach-Object {
				if(Test-ProjectBuildRequired -ProjectFilePath $_ -Configuration $Configuration){
					return $true;
				}
			}
		return $false;
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}