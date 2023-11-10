$myComputerName = $env:COMPUTERNAME

function Get-InfoCompSystem {
 [CmdletBinding()]
 param(
 [Parameter(Mandatory=$True)][string]$ComputerName
 )
 $cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName
 $prop = @{
            'Model' = $cs.model;
            'Manufacturer' = $cs.manufacturer;
            'Ram (GB)' = "{0:N2}" -f ($cs.totalphysicalmemory / 1GB);
            'Sockets' = $cs.numberofprocessors;
            'cores' = $cs.numberoflogicalprocessors
            }

            New-Object -TypeName PSObject -Property $prop
}

Get-InfoCompSystem -ComputerName $myComputerName