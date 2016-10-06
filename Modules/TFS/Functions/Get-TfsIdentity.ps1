function Get-TfsIdentity {
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
	[OutputType([Microsoft.TeamFoundation.Framework.Client.TeamFoundationIdentity])]
	[CmdletBinding()]
	Param(
		[parameter(Mandatory=$true)]
		[Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService] $Service,
		[parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[Microsoft.TeamFoundation.Framework.Client.IdentityDescriptor[]] $Descriptor,
		[switch] $Recurse,
		[int] $MaxCallDepth = 30,
		[int] $CurrentCallDepth = 0,
		[string] $Parent = "",
		[switch] $ShowEmptyGroups)
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
			"MaxCallDepth" = "Maximum call depth reached. Moving on.";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);		
	} Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		try {
			$idService.ReadIdentities($Descriptor, [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Direct, [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::TrueSid) | ForEach-Object {
				$id = $_;
				if ($id.IsContainer) {
					if ($id.Members.Count -gt 0) {
						if ($CurrentCallDepth -lt $MaxCallDepth -and $Recurse) { 
							$id.Members | Get-TfsIdentity -Service $Service -MaxCallDepth $MaxCallDepth -CurrentCallDepth ($CurrentCallDepth+1) -Parent $id.DisplayName -ShowEmptyGroups:$ShowEmptyGroups -Recurse:$Recurse;
						} else {
							if($Recurse){
								Write-Warning $formats.MaxCallDepth;
							}
						}
					} else {
						if ($ShowEmptyGroups) {
							New-Object -TypeName PSObject -Property @{Parent=$Parent; Name=$id.DisplayName; Type="Group" } | Select-Object Parent, Name, Type;
						}
					}
				} else {
					if ($id.UniqueName) {
						New-Object -TypeName PSObject -Property @{Parent=$Parent; Name=$id.UniqueName; Type="User" } | Select-Object Parent, Name, Type;
					} else {
						New-Object -TypeName PSObject -Property @{Parent=$Parent; Name=$id.DisplayName; Type="User" } | Select-Object Parent, Name, Type;
					}
				}
			}
		} catch {
			Write-Warning $_;
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

