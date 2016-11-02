function Add-UserToLocalGroup {
	<#
	.SYNOPSIS
		Adds domain user to local group

    .FUNCTIONALITY
		LocalGroup

    .DESCRIPTION
	    Adds domain user to local group.
	
    .PARAMETER GroupName
        Local machines permissions group name

    .PARAMETER DomainName
        Domain name of the users login domain
		
    .PARAMETER UserName
        Users domain login name
		
    .EXAMPLE
        #Adds the Foo\Bar user from the Foo domain into the local Administrators group (note: requires local admin permissions)
	    Add-UserToLocalGroup -GroupName "Administrators" -DomainName "Foo" -UserName "Bar"
		
    #>
	[OutputType([String])]
    [CmdletBinding(
        SupportsShouldProcess=$true,
		ConfirmImpact="High"
    )]
    param (
        [parameter(
			Mandatory=$true,
			HelpMessage="Local group name")]
		[string] $GroupName,
        [parameter(
			Mandatory=$true,
			HelpMessage="Domain name")]
		[string] $DomainName,
        [parameter(
			Mandatory=$true,
			HelpMessage="User login name")]
		[string] $UserName
    )
    Begin{
		$formats = @{
			"Begin" = "Begin {0}...";
			"Process" = "...processing {0}...";
			"End" = "...ending {0}";
		};
		Write-Verbose -Message ($formats.Begin -f $MyInvocation.MyCommand);
		$localGroup = [ADSI]"WinNT://$Env:COMPUTERNAME/$GroupName,group";
    } Process {
    	Write-Verbose -Message ($formats.Process -f $MyInvocation.MyCommand);
		if($pscmdlet.ShouldProcess("$GroupName : $DomainName \ $UserName")) {
			$localGroup.psbase.Invoke("Add",([ADSI]"WinNT://$DomainName/$UserName").path)
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}