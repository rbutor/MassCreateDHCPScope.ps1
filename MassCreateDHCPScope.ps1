$csv = Import-Csv C:\\DHCP.csv
$dhcpServer = get-content env:computername
foreach($line in $csv)
{
$site=$line.siteName
$state=$line.state
$scopeName=$site+", "+$state+" - "+$desc
$startIP=$line.startIP
$endIP=$line.endIP
$excludeStart=$line.excludeStart
$excludeEnd=$line.excludeEnd
$gateway=$line.gateway
$mask=$line.mask
$desc=$line.desc
$intDNS1="10.21.16.222"
$intDNS2="10.212.145.21"
$exDNS1="8.8.8.8"
$exDNS2="208.67.222.222"
$domain=$line.domain
$dnsArray = $intDNS1,$intDNS2
$guestDNSArray = $exDNS1,$exDNS2
 
$scopeID = (Add-DhcpServerv4Scope -Name $scopeName -StartRange $startIP -EndRange $endIP -SubnetMask $mask -Description $desc –cn $dhcpServer -PassThru).ScopeID
#Add-DhcpServerv4ExclusionRange -ScopeID $scopeID -StartRange $excludeStart -EndRange $excludeEnd
Set-DhcpServerv4OptionValue -ComputerName $dhcpServer -DnsServer $dnsArray -DnsDomain $domain -Router $gateway -force
Add-DhcpServerv4FailoverScope -ComputerName $dhcpServer -Name "dhcp01-dhcp02" -ScopeID $scopeID
}
