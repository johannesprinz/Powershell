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
		$tcpAliasName = "DBMSSOCN,{0}.{1}" -f $computerSystem.DNSHostName, $computerSystem.Domain;
		$connectTos = 	"HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo", 
						"HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo";
		if($PortNumber) {
			$tcpAliasName += ",$PortNumber";
		}
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$connectTos | Foreach-Object {
			if(-not(Test-Path -Path $_)) {
				New-Item -Path $_ -ItemType Container | Out-Null;
			}
			if(Get-ItemProperty -Path $_ -Name $AliasName -ErrorAction SilentlyContinue) {
				Set-ItemProperty -Path $_ -Name $AliasName -Value $tcpAliasName;
			} else {
				New-ItemProperty -Path $_ -Name $AliasName -PropertyType string -Value $tcpAliasName | Out-Null;
			}
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

# TODO Output Name, Value collection so you could pipe into Remove-SQLAlias
function Get-SQLAlias {
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

function Test-SQLAlias {
	[OutputType([Boolean])]
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
		$objSQLConnection = New-Object System.Data.SqlClient.SqlConnection
		$objSQLCommand = New-Object System.Data.SqlClient.SqlCommand
		try {
			$objSQLConnection.ConnectionString = "Server=$AliasName;Integrated Security=SSPI;"
			Write-Verbose "Testing access to SQL server/instance/alias: $AliasName"
			Write-Verbose " - Trying to connect to $AliasName..."
			$objSQLConnection.Open() | Out-Null
			Write-Verbose  "...Success"
			$strCmdSvrDetails = "SELECT SERVERPROPERTY('productversion') as Version"
			$strCmdSvrDetails += ",SERVERPROPERTY('IsClustered') as Clustering"
			$objSQLCommand.CommandText = $strCmdSvrDetails
			$objSQLCommand.Connection = $objSQLConnection
			$objSQLDataReader = $objSQLCommand.ExecuteReader()
			if ($objSQLDataReader.Read()) {
				Write-Verbose (" - SQL Server version is: {0}" -f $objSQLDataReader.GetValue(0))
				if ($objSQLDataReader.GetValue(1) -eq 1) {
					Write-Verbose " - This instance of SQL Server is clustered"
				} else {
					Write-Verbose " - This instance of SQL Server is not clustered"
				}
			}
			$objSQLDataReader.Close();
			$objSQLConnection.Close();
			return $true;
		} catch {
			$errText = $error[0].ToString()
			if ($errText.Contains("network-related"))
			{
				Write-Verbose "Connection Error. Check server name, port, firewall."
			} elseif ($errText.Contains("Login failed")) {
				Write-Verbose " - Not able to login. SQL Server login not created."
			} elseif ($errText.Contains("Unsupported SQL version")) {
				Write-Verbose " - SharePoint 2010 requires SQL 2005 SP3+CU3, SQL 2008 SP1+CU2, or SQL 2008 R2."
			} else {
				if (!([string]::IsNullOrEmpty($serverRole))) {
					Write-Verbose " - $currentUser does not have `'$serverRole`' role!"
				}
				else {Write-Verbose " - $errText"}
			}
			return $false;
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }        
}