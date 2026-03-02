# Import a file
$BronzePSU   = Import-Csv -Path .\Measurements\bronze-atx-psu.csv
$GoldPSU     = Import-Csv -path .\Measurements\gold-sfx-psu.csv
$PlatinumPSU = Import-Csv -path .\Measurements\platinum-atx-psu.csv

# Convert rows to objects with HourSinceStart
$HourlyBronze   = (Build-AggregateHourly -InputCSV $BronzePSU)
$HourlyGold     = (Build-AggregateHourly -InputCSV $GoldPSU)
$HourlyPlatinum = (Build-AggregateHourly -InputCSV $PlatinumPSU)

$chart = New-CustomizedChart -ChartTitle "Bronze, Gold and platinum rated PSU" -YAxisTitle "Watt" -XaxisTitle "Hours Since Start"

# ----First measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Bronze PSU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "SandyBrown" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyBronze)
{
    $Series.Points.AddXY($line.HourSinceStart, $Line.AveragePower)
}
$Chart.Series.Add($Series)

# ----Second measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Gold PSU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "Green" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyGold)
{   
    $Series.Points.AddXY($line.HourSinceStart, $Line.AveragePower)
}
$Chart.Series.Add($Series)

# ----Third measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Platinum PSU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "Blue" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 3 # Set a bit thicker to show up better against background

# Iterate over all lines in CSV and add them to chart
foreach($Line in $HourlyPlatinum)
{
    $Series.Points.AddXY($line.HourSinceStart, $Line.AveragePower)
}
$Chart.Series.Add($Series)

# Finally save and open
$Chart.SaveImage("Images\BronzeGoldAndPlatinum.png", "png")
Start-Process .\Images\BronzeGoldAndPlatinum.png
