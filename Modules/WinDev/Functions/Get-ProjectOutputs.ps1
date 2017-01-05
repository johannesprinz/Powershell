function Get-ProjectOutputs {
	[OutputType([String])]
    [CmdletBinding()]
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
		$content = [XML](Get-Content $ProjectFilePath);
		$outputPath = ($content.Project.PropertyGroup | 
			Where-Object { 
				$null -ne $_ -and 
				$null -ne $_.Condition -and 
				$_.Condition.Contains("'$Configuration|") 
			} | 
			Select-Object -First 1).OutputPath;
			(Join-Path -Path (Split-Path -Path $ProjectFilePath -Parent) -ChildPath $outputPath)
		Get-ChildItem -Path (Join-Path -Path (Split-Path -Path $ProjectFilePath -Parent) -ChildPath $outputPath) -Recurse | 
			ForEach-Object {
				Write-Output $_.FullName;
			}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}