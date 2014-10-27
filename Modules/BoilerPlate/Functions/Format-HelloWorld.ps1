function Format-HelloWorld {
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
	$date = Get-Date;
	return "Welcome to Hello World $Name on $date";
}
