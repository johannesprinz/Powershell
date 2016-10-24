function Set-ProxyCredential {
	<#
	.SYNOPSIS
		Sets the proxy credentials

    .FUNCTIONALITY
		Proxy

    .DESCRIPTION
	    Applies the proxy credentials to use on all outgoing traffic for this session.
	
    .PARAMETER Credential
        Web proxy credential you'll be prompted if not supplied and not using -UseDefault

    .PARAMETER UseDefault
        Use the current sessions credentials for all proxy authentication
		
    .EXAMPLE
        #Sets the given credentials for proxy authentication
	    $cred = Get-Credential;
		Set-ProxyCredential -Credential $cred

	.EXAMPLE
        #Prompts for then sets the given credentials for proxy authentication
	    Set-ProxyCredential

    .EXAMPLE
        #Sets the current sessions credentials for proxy authentication
	    Set-ProxyCredential -UseDefault
		
    #>
	[OutputType([String])]
    [CmdletBinding(
		DefaultParameterSetName="Default",
		SupportsShouldProcess=$true,
		PositionalBinding=$true,
		ConfirmImpact="Medium"
    )]
    param (
        [parameter(
			ParameterSetName="Default",
			Mandatory=$false,
			HelpMessage="Web proxy credentials.")]
		[PSCredential] $Credential,
        [parameter(
			ParameterSetName="UseDefault",
			Mandatory=$true,
			HelpMessage="Use currently logged on user credentials.")]
		[Switch] $UseDefault
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$webclient=New-Object System.Net.WebClient;
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		if($UseDefault) {
			if($pscmdlet.ShouldProcess("DefaultCredentials")) {
				$webclient.UseDefaultCredentials;
			}
		} else {
			if($null -eq $Credential){
				$Credential = Get-Credential -Message "Web proxy credential:";
			}
			if($pscmdlet.ShouldProcess("DefaultCredentials")) {
				$webclient.Proxy.Credentials=$Credential;
			}
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}