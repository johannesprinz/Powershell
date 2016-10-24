function Ping-Uri {
	<#
	.SYNOPSIS
		Ping for web endpoints

    .FUNCTIONALITY
		Uri

    .DESCRIPTION
	    This provides ping like functionality against http based endpoints.
	
    .PARAMETER Uri
        Path to resource

	.EXAMPLE
        #Pings local host
	    Ping-Uri "http://localhost"

    .EXAMPLE
        #Similar to ping localhost -t where -t Ping the specified host until stopped. To see statistics and continue - type Control-Break; To stop - type Control-C.
	    while(1) {
			Write-Output ("{0}:{1}" -f (Get-Date), (Ping-Uri "http://localhost" -ErrorAction SilentlyContinue));
			Start-Sleep -Seconds 3;
		};
		
    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
		[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]$Uri
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
		try {
			$request = [system.Net.WebRequest]::Create($Uri);
			$request.UseDefaultCredentials = $true;
			$response = $request.GetResponse();
			return $response.StatusCode;
		} catch {
			return "500"
		}
    } End {	
    	Write-Verbose -Message ($formats.End -f $MyInvocation.MyCommand);
    }
}
