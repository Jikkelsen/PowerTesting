function Build-AggregateHourly 
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory)]
        $InputCSV
    )    
    
    # Used to calculate time in measurement from date
    $StartDate = Get-Date($InputCSV[0].Time)

    # Start conversion
    $processed = foreach ($Line in $InputCSV)
    {
        #reset skip variable
        $skip = $false
        
        # skip this line, if either of the properties are not set 
        foreach ($property in $line.PSObject.Properties)
        {
            if ($property.value -eq "") 
            {
                Write-Verbose "Skipping line"
                $skip = $true
            }
        } 
        
        # If all properties are present, append the hours since start variable 
        if (-not $skip) 
        {
            $currentTime    = [datetime]$line.time
            $hourSinceStart = [math]::Floor(($currentTime - $StartDate).TotalHours)

            [PSCustomObject]@{
                Date           = $line.time
                CPUPackage     = $line.'CPU Usage (%)'
                CPU1_temp      = $line.'CPU1 Temp (°C)'
                CPU2_temp      = $line.'CPU2 Temp (°C)'
                PowerDraw      = [double]$line."Power Draw"
                Voltage        = $line.Voltage
                Current        = $line.Current
                HourSinceStart = [int]$hourSinceStart
            }
        }
    }

    # Group by HourSinceStart and calculate hourly averages
    $hourly = $processed | Group-Object HourSinceStart | ForEach-Object {
            
        $avgPower   = ($_.Group | Measure-Object PowerDraw -Average).Average
            $avgpackage = ($_.Group | Measure-Object CPUPackage -average).Average
            $avgCPU1    = ($_.Group | Measure-Object CPU1_temp -average).Average
            $avgCPU2    = ($_.Group | Measure-Object CPU2_temp -average).Average
            $avgVoltage = ($_.Group | Measure-Object Voltage -average).Average
            $avgCurrent = ($_.Group | Measure-Object Current -average).Average

            [PSCustomObject]@{
                HourSinceStart = [int]$_.Name
                AveragePower   = [math]::Round($avgPower, 3)
                avgpackage     = [math]::Round($avgpackage, 3)
                avgcpu1        = [math]::Round($avgCPU1, 3)
                avgcpu2        = [math]::Round($avgCPU2, 3)
                avgvolt        = [math]::Round($avgVoltage, 3)
                avgcurrent     = [math]::Round($avgCurrent, 3)
            }
        } | Sort-Object HourSinceStart
    return $hourly
}