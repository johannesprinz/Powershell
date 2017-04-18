function Disable-Proxy {
	<#
	.SYNOPSIS
		Disables the proxy settings

    .FUNCTIONALITY
		Proxy

    .DESCRIPTION
	    Disable the proxy settings in Internet Options aka Internet Properties.
	
    .EXAMPLE
        #Enables the proxy for previously set Uri
	    Disable-Proxy
		
    #>
	[OutputType([String])]
    [CmdletBinding(
        SupportsShouldProcess=$true,
		ConfirmImpact="High"
    )]
    Param()
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
		Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 0;
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}
