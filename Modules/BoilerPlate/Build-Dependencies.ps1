if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Get-ProxyCredential {
    <#
    .SYNOPSIS
		Gets and applies proxy credentials if required.

    .FUNCTIONALITY
		ProxyCredentials

    .DESCRIPTION
	    Gets and applies proxy credentials (if required) to the default ie proxy settings to enable http requests from the current powershell session.

    .EXAMPLE
        #Simple and only way to call this function
	    Set-ProxyCredentials

		#>
	Begin{
		$webclient = New-Object System.Net.WebClient;
	} Process {
		if(-not($webclient.Proxy.IsBypassed((Get-PSRepository | Select-Object -First 1).SourceLocation))) {
			$credential = Get-Credential -Message "Enter Proxy authentication credentials";
			$webclient.Proxy.Credentials=$credential;
		}
	} End {	}
}

Get-ProxyCredential

$dependencies = "Psake", "Pester", "PSScriptAnalyzer";
$dependencies | ForEach-Object {
	if($null -eq (Get-Module -Name $_)) {
		Install-Module -Name $_;
	}
};
