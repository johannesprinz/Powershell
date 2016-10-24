function Enable-Proxy {
	<#
	.SYNOPSIS
		Enables the proxy settings in Internet Options aka Internet Properties

    .FUNCTIONALITY
		Proxy

    .DESCRIPTION
	    Enables the proxy settings and sets the proxy uri in Internet Options aka Internet Properties.
	
    .PARAMETER Uri
        Uri to the web proxy including the port number

    .EXAMPLE
        #Enables and sets the proxy to example.com:8080 
	    Enable-Proxy -Uri example.com:8080

    .EXAMPLE
        #Enables the proxy for previously set Uri
	    Enable-Proxy
		
    #>
	[OutputType([String])]
    [CmdletBinding(
        SupportsShouldProcess=$true,
		ConfirmImpact="High"
    )]
    param (
        [parameter(
			Mandatory=$false,
			HelpMessage="Web proxy uri with port number.")]
		[System.Uri] $Uri
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$internetSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		if($Uri){
			Set-ItemProperty -Path $internetSettings -Name ProxyServer -Value $Uri.AbsoluteUri;
		}
		Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 1;
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}