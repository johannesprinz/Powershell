#TODO Takin [] of alias, portnmumber as piepline args
function Set-SQLAlias {
	<#
	.SYNOPSIS
		Sets the sql client alias

    .FUNCTIONALITY
		SQL Alias

    .DESCRIPTION
	    Applies the sql alias to both 32 and 64 bit clients.
	
    .PARAMETER AliasName
        Name of the SQL alias to use.

    .PARAMETER PortNumber
        Post number of the sql connection. Uses dynamic if not specified
		
    .EXAMPLE
        #Sets the given credentials for proxy authentication
	    $cred = Get-Credential;
		Set-ProxyCredential -Credential $cred

	.EXAMPLE
        #Sets up a SharePoint SQL Alias using dynamic ports
	    Set-SQLAlias -AliasName SharePointSQL
		
	.EXAMPLE
        #Sets up a SharePoint SQL Alias using port 1433
	    Set-SQLAlias -AliasName SharePointSQL -PortNumber 1433		
    #>
    [CmdletBinding(
		SupportsShouldProcess=$true,
		PositionalBinding=$true,
		ConfirmImpact="Medium"
    )]
    param (
        [parameter(
			Mandatory=$true,
			HelpMessage="SQL alias name")]
		[string] $AliasName,
        [parameter(
			Mandatory=$false,
			HelpMessage="SQL client port number")]
		[string] $PortNumber
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$computerSystem = Get-WmiObject win32_computersystem;
		$fqdn = "{0}.{1}" -f $computerSystem.DNSHostName, $computerSystem.Domain;
		$connectTos = 	"HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo", 
						"HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo";
		$tcpAliasName = "DBMSSOCN,{0}.{1}" -f $computerSystem.DNSHostName, $computerSystem.Domain;
		if($PortNumber) {
			$tcpAliasName += ",$PortNumber";
		}
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$connectTos | Foreach-Object {
			if(-not(Test-Path -Path $_)) {
				$swallowOutput = New-Item -Path $_ -ItemType Container
			}
			if(Get-ItemProperty -Path $_ -Name $AliasName -ErrorAction SilentlyContinue) {
				Set-ItemProperty -Path $_ -Name $AliasName -Value $tcpAliasName;
			} else {
				$swallowOutput = New-ItemProperty -Path $_ -Name $AliasName -PropertyType string -Value $tcpAliasName;
			}
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

# TODO Output Name, Value collection so you could pipe into Remove-SQLAlias
function Get-SQLAlias {
	[OutputType([PSCustomObject])]
    [CmdletBinding()]
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$connectTos = 	"HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo", 
						"HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo";		
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$connectTos | Foreach-Object {
			Get-ItemProperty -Path $_;
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

# TODO Take in string[] of Alias names property name from pipeline
function Remove-SQLAlias {
    [CmdletBinding(
		SupportsShouldProcess=$true,
		PositionalBinding=$true,
		ConfirmImpact="Medium"
    )]
    param (
        [parameter(
			Mandatory=$true,
			HelpMessage="SQL alias name")]
		[string] $AliasName
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$connectTos = 	"HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo", 
						"HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo";		
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$connectTos | Foreach-Object {
			Remove-ItemProperty -Path $_ -Name $AliasName;
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}