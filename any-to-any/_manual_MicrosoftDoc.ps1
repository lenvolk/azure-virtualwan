# Ref: https://learn.microsoft.com/en-us/azure/virtual-wan/site-to-site-powershell

Connect-AzAccount
Get-AzSubscription
Select-AzSubscription -SubscriptionName "LabSub"


New-AzResourceGroup -Location "West US" -Name "testRG"

$virtualWan = New-AzVirtualWan -ResourceGroupName testRG -Name myVirtualWAN -Location "West US"

$virtualHub = New-AzVirtualHub -VirtualWan $virtualWan -ResourceGroupName "testRG" -Name "westushub" -AddressPrefix "10.11.0.0/24" -Location "westus"

# Create a site-to-site VPN gateway
New-AzVpnGateway -ResourceGroupName "testRG" -Name "testvpngw" -VirtualHubId $virtualHub.Id -VpnGatewayScaleUnit 2
Get-AzVpnGateway -ResourceGroupName "testRG" -Name "testvpngw"

# Create a site and connections

$vpnGateway = Get-AzVpnGateway -ResourceGroupName "testRG" -Name "testvpngw"
$vpnSiteAddressSpaces = New-Object string[] 2
$vpnSiteAddressSpaces[0] = "10.100.0.0/16"

$vpnSiteLink1 = New-AzVpnSiteLink -Name "testVpnSiteLink1" -IpAddress "20.232.170.109" -LinkProviderName "Microsoft" -LinkSpeedInMbps "10"

$vpnSite = New-AzVpnSite -ResourceGroupName "testRG" -Name "testVpnSite" -Location "West US" -VirtualWan $virtualWan -AddressSpace $vpnSiteAddressSpaces -DeviceModel "MyDevice" -DeviceVendor "Microsoft" -VpnSiteLink @($vpnSiteLink1)