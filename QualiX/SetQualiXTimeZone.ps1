

$RemoteUsername = "root"
$RemotePassword = "qs1234"
$regexIp = "192.168.65.28"

Write-Host "Get QualiX UTC time"  -ForegroundColor Green
$plink = "echo y | .\plink -ssh -l $RemoteUsername -pw ""$RemotePassword"" ""$regexIp"" date -u"
$result = Invoke-Expression -Command:$plink
write-host "QualiX UTC Time: " $result -ForegroundColor Red

$time = Get-Date
$time = $time.ToUniversalTime()
write-host "Machine UTC Time: " $time -ForegroundColor Red


# make local machine UTC Time in format: HH:mm:ss
$time -match '((\d+):(\d+):(\d+))'
$hour = $Matches.2
$minute = $Matches.3
$second = $Matches.4

$hour = '{0:d2}' -f [int]$hour
$time = "$($hour):$($minute):$($second)"
write-host "paresd time is " $time -ForegroundColor Yellow
 

Write-Host "Set QualiX time to be: " $time -ForegroundColor Green
$plink = ".\plink -ssh -l $RemoteUsername -pw ""$RemotePassword"" ""$regexIp"" unlink /etc/localtime"
Invoke-Expression -Command:$plink

Write-Host "Set QualiX time to be: " $time -ForegroundColor Green
$command = "date -s " + $time
$plink = ".\plink -ssh -l $RemoteUsername -pw ""$RemotePassword"" ""$regexIp"" ""$command"""
Invoke-Expression -Command:$plink