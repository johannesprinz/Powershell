function Get-TfsGroup {
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
	[OutputType([Microsoft.TeamFoundation.Framework.Client.TeamFoundationIdentity[]])]
	[CmdletBinding()]
	Param(
		[parameter(Mandatory=$true)]
		[Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService] $Service,
		[parameter(Mandatory=$false, ValueFromPipeline=$true)]
		[string[]] $Project)
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
			"InvalidProject" = "Invalid project name: {0}";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);		
	} Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$Project | ForEach-Object {
			$projectName = $_;
			try {
				return $Service.ListApplicationGroups($projectName, [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::TrueSid);
			} catch {
				Write-Warning ($formats.InvalidProject -f $projectName);
			}
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

