function Monitor-MemoryUsage {
    param (
        # Memory threshold in MB
        [Parameter(Mandatory=$true)]
        [int]$memoryThreshold,

        # Log file path
        [Parameter(Mandatory=$true)]
        [string]$logFilePath
    )

    # Get the current date and time
    $timestamp = Get-Date

    # Get the list of running processes
    $processes = Get-Process

    $totalMemoryUsage = 0;

    # Loop through each process
    foreach ($process in $processes) {
        # Calculate the memory usage in MB
        $memoryUsage = $process.PM / 1GB
        $totalMemoryUsage += $memoryUsage;     

        # Check if the memory usage exceeds the threshold
        if ($memoryUsage -gt $memoryThreshold) {
            # Get the service associated with the process
            $service = Get-WmiObject -Query "SELECT * FROM Win32_Service WHERE ProcessId=$($process.Id)"

               if($service -ne $null) {
                $serviceExists = Get-Service | Where-Object { $_.Name -eq $service.Name }
                 
                 if($serviceExists -ne $null) {
                        # Log the details
                        Add-Content -Path $logFilePath -Value "$timestamp | $($process.Name) | $($service.DisplayName) | Process Memory Usage : $memoryUsage GB | Total System Memory Utilization: $totalMemoryUsage"

                        # Restart the service
                        Restart-Service -Name $service.Name -Force
                 }
                
            }
           
        }
    }
}

Monitor-MemoryUsage -memoryThreshold 60 -logFilePath "C:\Users\admin\Documents\WindowsPowerShell\Log\log.txt"

