function Get-Projects {
	[OutputType([String])]
    [CmdletBinding()]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$SolutionFilePath
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
		Get-Content $SolutionFilePath |
			Select-String 'Project\(' |
				ForEach-Object {
					$projectParts = $_ -Split '[,=]' | ForEach-Object { $_.Trim('[ "{}]') };
					New-Object PSObject -Property @{
						Name = $projectParts[1];
						File = $projectParts[2];
						Guid = $projectParts[3]
					}
				} | 
				Where-Object {
					$_.File.Contains("proj")
				} | ForEach-Object {
					Write-Output (Join-Path -Path (Split-Path -Path $SolutionFilePath -Parent) -ChildPath $_.File);
				}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}
