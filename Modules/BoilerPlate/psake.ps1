function Test-Module($Name, $MinimumVersion){
	$null -ne (Get-Module -ListAvailable -Name $Name | 
	Where-Object {
		 $null -eq $MinimumVersion -or 
		 [System.Version]::Parse($MinimumVersion) -le $_.Version
	});
}
$requiredModules = @(
	@{Name="psake"; MinimumVersion=4.6.0;},
	@{Name="Pester"; MinimumVersion=4.0.2;},
	@{Name="PSScriptAnalyzer"; MinimumVersion=1.10.0;}
)
if($null -ne [System.Net.WebRequest]){
	[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials;
}
if(-not(Test-Module -Name "PowerShellGet")) {
	Write-Error -Message "PowerShellGet module not found. You can get it from here: https://www.powershellgallery.com/" -Category NotInstalled;
} else {
	if(-not (Get-PackageProvider -Name NuGet)){
		Install-PackageProvider -Name Nuget
	}
	if(-not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue)){
		Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2;
	}
	$requiredModules | ForEach-Object {
		if(-not (Test-Module -Name $_.Name -MinimumVersion $_.MinimumVersion)){
			Install-Module -Name $_.Name -MinimumVersion $_.MinimumVersion;
		}
	}
	$requiredModules | ForEach-Object {
		if(-not (Get-Module -Name $_.Name -ErrorAction SilentlyContinue)){
			Import-Module -Name $_.Name;
		}
	}
	Write-Information -InformationAction Continue -MessageData "> Invoke-psake [Task Name]  #To execute task"
	Write-Information -InformationAction Continue -MessageData "> Invoke-psake [Task Name] -verbose  #To execute task with verbose logging"
	Write-Information -InformationAction Continue -MessageData "> Invoke-psake -docs  #To get this list of task"
	Push-Location -Path $PSScriptRoot;
	Invoke-psake -docs -nologo;
}
