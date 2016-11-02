function Get-TFSGroupMembership {
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
	[CmdletBinding()]
	Param(
		[parameter(Mandatory=$true, ParameterSetName="Given")]
		[string] $CollectionUrl,
		[parameter(Mandatory=$false, ParameterSetName="Given")]
		[string[]] $ProjectName, 
		[parameter(Mandatory=$false, ParameterSetName="Default")]
		[parameter(Mandatory=$false, ParameterSetName="Given")]
        [switch] $ShowEmptyGroups)
	Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
			"ConnectionError" = "Error occurred trying to connect to tfs";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$server = $null;
		$projects = @();
		if($CollectionUrl) {
			$server = Get-TfsServer -Name $CollectionUrl; #http://dnzwgtfs2013:8080/tfs;		
		}
		if(-not $server) {
			$picker = Show-TfsServerDialog;
			$server = $picker.SelectedTeamProjectCollection;
			$projects = $picker.SelectedProjects;
		}
		if($ProjectName){
			$projects = $ProjectName | Get-TfsProject -Server $server;
		}	
		try {
			$server.EnsureAuthenticated();
		} catch {
			Write-Error $formats.ConnectionError;
			return $null;
		}
		$idService = $server.GetService("Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService");
	} Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$projects | ForEach-Object {
			$parent = $_.Name;
			Write-Verbose $parent;
			$identityDescriptors = $parent | Get-TfsGroup -Service $idService | Select-Object -Property Descriptor;
			$identityDescriptors | Get-TfsIdentity -Service $idService -ShowEmptyGroups:$ShowEmptyGroups -Parent $parent -Recurse;
		}	

		$root = $idService.ReadIdentities(
			[Microsoft.TeamFoundation.Framework.Common.IdentitySearchFactor]::AccountName,
			"Project Collection Valid Users",
			[Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Expanded,
			[Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::TrueSid);
		$root.Members | Get-TfsIdentity -Service $idService -ShowEmptyGroups -Parent $root.DisplayName;
	} End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

