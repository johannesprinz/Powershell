function Get-TfsProject {
	<#
	https://technet.microsoft.com/en-us/library/dd819489.aspx HelpKeyWords
    .SYNOPSIS
		What this does

    .FUNCTIONALITY
		What this does against

    .DESCRIPTION
	    Full description
	
    .PARAMETER Param1
        What's this input

    .PARAMETER Param2
	    What's this input

        Default value is $True

    .EXAMPLE
        #Description of example
	    Comandline version of example

    .EXAMPLE
        #Description of example
	    Comandline version of example
		
    #>
	[OutputType([Microsoft.TeamFoundation.Server.ProjectInfo])]
	[CmdletBinding()]
	Param(
		[parameter(Mandatory=$true)]
		[Microsoft.TeamFoundation.Client.TfsConnection] $Server,
		[parameter(Mandatory=$false, ValueFromPipeline=$true)]
		[string[]] $Projects)
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
			"InvalidProject" = "Invalid project name: {0}";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$cssService = $Server.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3");
	} Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);;
		if($Projects){
			$Projects | ForEach-Object {
				$projectName = $_;
				try {
					$project = $cssService.GetProjectFromName($projectName);
					return $project;
				} catch {
					Write-Warning ($formats.InvalidProject -f $projectName);
				}
			}
		} else {
			return $cssService.ListAllProjects();
		}    	
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);;
    }
}

