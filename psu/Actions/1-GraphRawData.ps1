# Adding Type is important
Add-Type -AssemblyName System.Windows.Forms.Datavisualization
function prompt {"Ottetal:\ "}
. .\Functions\Build-AggregateHourly.ps1
. .\Functions\New-CustomizedChart.ps1

# Import a file
$BronzePSU = Import-Csv -Path .\Measurements\bronze-atx-psu.csv

# List it's size and sample
$BronzePSU.Count
$BronzePSU[0]

# Initialize chart
$chart = New-CustomizedChart -ChartTitle "Bronze rated PSU raw" -YAxisTitle "Watt" -XaxisTitle "Time"

# First measurement
$Series             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.Name        = "Bronze PSU"
$Series.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Series.Color       = "SandyBrown" # See https://learn.microsoft.com/en-us/dotnet/api/system.drawing.color?view=netframework-4.8.1
$Series.BorderWidth = 1

# Iterate over all lines in CSV and add them to chart
foreach($Line in $BronzePSU)
{
    $Series.Points.AddXY($($Line.Time),$($Line.'Power Draw'))
}
$Chart.Series.Add($Series)

# Finally save and open
$Chart.SaveImage("psu\Images\RawBronze.png", "png")
Start-Process .\Images\RawBronze.png