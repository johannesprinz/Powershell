function Show-TfsServerDialog {
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
	[OutputType([Microsoft.TeamFoundation.Client.TeamProjectPicker])]
	$picker = New-Object Microsoft.TeamFoundation.Client.TeamProjectPicker([Microsoft.TeamFoundation.Client.TeamProjectPickerMode]::MultiProject, $false);
    $dialogResult = $picker.ShowDialog();
    if ($dialogResult -ne "OK") {
		exit;
	}
    $picker;
}