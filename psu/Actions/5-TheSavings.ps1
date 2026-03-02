# Import Raw Files
$BronzePSU   = Import-Csv -Path .\Measurements\bronze-atx-psu.csv
$GoldPSU     = Import-Csv -path .\Measurements\gold-sfx-psu.csv
$PlatinumPSU = Import-Csv -path .\Measurements\platinum-atx-psu.csv

# Calculate Raw files
$SumBronzePower   = ($BronzePSU.'Power Draw'   | Measure-Object -AllStats)
$SumGoldPower     = ($GoldPSU.'Power Draw'     | Measure-Object -AllStats)
$SumPlatinumPower = ($PlatinumPSU.'Power Draw' | Measure-Object -AllStats)

# Build Aggregates
$HourlyBronze   = (Build-AggregateHourly -InputCSV $BronzePSU)
$HourlyGold     = (Build-AggregateHourly -InputCSV $GoldPSU)
$HourlyPlatinum = (Build-AggregateHourly -InputCSV $PlatinumPSU)

# Calcualte Aggregates
$SumBronzeHourly   = ($HourlyBronze.AveragePower   | Measure-Object -AllStats)
$SumGoldHourly     = ($HourlyGold.AveragePower     | Measure-Object -AllStats)
$SumPlatinumHourly = ($HourlyPlatinum.AveragePower | Measure-Object -AllStats)

# Savings 
$WattSaving           = $SumBronzeHourly.Average - $SumPlatinumHourly.Average
$SavedWattHoursDay    = $WattSaving * 24 
$SavedkWhDay          = $SavedWattHoursDay / 1000
$SavedkWhYear         = $SavedkWhDay * 365
$CurrentPowerPrice    = 1.23 # https://elpris2alt.wen.dk/

$SavedDollarsPerYear  = [System.Math]::Round($SavedkWhYear * $CurrentPowerPrice,2)
Write-Host ("`n`n" + 'You save $' + $SavedDollarsPerYear + ' per year!' + "`n`n") -BackgroundColor Green