﻿$myComputerName = $env:COMPUTERNAME

function Get-InfoBadService {
    [CmdletBinding()]
    Param(
        [Parameter (Mandatory=$True)][string]$ComputerName
    )

    $svcs = Get-WmiObject -class Win32_Service -ComputerName $ComputerName -Filter "StartMode= 'Auto' AND  State <> 'Running'"

    foreach ($svc in $svcs)
    {
        $props = @{
            'ServiceName' = $svc.name;
            'LogonAccount' = $svc.startname;
            'DisplayName' = $svc.displayName;
        }
        New-Object -TypeName PSObject -Property $props
    }
}

Get-InfoBadService -ComputerName $myComputerName