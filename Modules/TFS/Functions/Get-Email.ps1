function Get-Email {
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
	[OutputType([String])]
    [CmdletBinding()]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
    	Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		$Name | ForEach-Object {
			if($_.Contains('\')) {
				$lookupValue = $_.Split('\')[1];
			} else {
				$lookupValue = $_;
			}		
			$query = "SELECT * FROM ds_user where ds_sAMAccountName='$lookupValue'";
			$user = Get-WmiObject -Query $query -Namespace "root\Directory\LDAP";
			return $user.DS_mail;
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}

