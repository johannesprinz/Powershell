$connections = @{
	"Connection #1" = @{"BSValue" = 256; "GatewayList" = "172.18.99.188:8443"; "ConnectionAlias" = "IDMEDEV01";};
	"Connection #2" = @{"BSValue" = 256; "GatewayList" = "172.18.99.169:8443"; "ConnectionAlias" = "IDMEDEV02";};
	"Connection #3" = @{"BSValue" = 260; "GatewayList" = "172.18.99.164:8443"; "ConnectionAlias" = "idmetst01";};
	"Connection #4" = @{"BSValue" = 260; "GatewayList" = "172.18.98.131:8443"; "ConnectionAlias" = "IDMETST03";};
	"Connection #5" = @{"BSValue" = 772; "GatewayList" = "172.18.99.162:8443"; "ConnectionAlias" = "baudev";};
	"Connection #6" = @{"BSValue" = 256; "GatewayList" = "172.18.99.172:8443"; "ConnectionAlias" = "WVDEV01";};
	"Connection #7" = @{"BSValue" = 256; "GatewayList" = "172.18.99.175:8443"; "ConnectionAlias" = "wvtst02";};
	"Connection #8" = @{"BSValue" = 256; "GatewayList" = "172.18.99.176:8443"; "ConnectionAlias" = "WVTST";};
};
$VPNPlusClient = 'HKLM:\SOFTWARE\WOW6432Node\VMware, Inc.\SSL VPN-Plus Client\';

$connections.Keys | ForEach-Object {
	if(-not (Test-Path -Path "$VPNPlusClient\$_")) {
		New-Item -Path $VPNPlusClient -Name $_ -ItemType Container		
	}
	Set-ItemProperty -Path ("$VPNPlusClient\$_") -Name ConnectionAlias -Value $connections.$_.ConnectionAlias
	Set-ItemProperty -Path ("$VPNPlusClient\$_") -Name BSValue -Value $connections.$_.BSValue
	Set-ItemProperty -Path ("$VPNPlusClient\$_") -Name GatewayList -Value $connections.$_.GatewayList
}
Set-ItemProperty -Path $VPNPlusClient -Name ConnectionCount -Value $connections.Count