# Let's assume you have the same stats from .\5-TheSavings.ps1 in memory
$BronzeToEquipment   = $SumBronzeHourly.Average   * 0.85
$GoldToEquipment     = $SumGoldHourly.Average     * 0.90
$PlatinumToEquipment = $SumPlatinumHourly.Average * 0.92

Write-Host "Bronze uses: $([Math]::Round($BronzeToEquipment,2)) watts" -BackgroundColor Green
Write-Host "Gold uses: $([Math]::Round($GoldToEquipment,2)) watts" -BackgroundColor Green
Write-Host "Platinum uses: $([Math]::Round($PlatinumToEquipment,2)) watts" -BackgroundColor Green


$chart = New-CustomizedChart -ChartTitle "CPU utilization" -YAxisTitle "Percent Usage" -XaxisTitle "Hours Since Start"

# ----First measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Bronze PSU - CPU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "SandyBrown" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyBronze)
{
    $Series.Points.AddXY($line.HourSinceStart, $Line.avgpackage)
}
$Chart.Series.Add($Series)

# ----Second measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Gold PSU - CPU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "Green" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyGold)
{   
    $Series.Points.AddXY($line.HourSinceStart, $Line.avgpackage)
}
$Chart.Series.Add($Series)

# ----Third measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Platinum PSU - CPU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "Blue" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyPlatinum)
{
    $Series.Points.AddXY($line.HourSinceStart, $Line.avgpackage)
}
$Chart.Series.Add($Series)

# Finally save and open
$Chart.SaveImage("Images\CPUUtilizations.png", "png")
Start-Process .\Images\CPUUtilizations.png
