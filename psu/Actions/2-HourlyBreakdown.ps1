# Import a file
$BronzePSU = Import-Csv -Path .\measurements\bronze-atx-psu.csv

# Convert rows to objects with HourSinceStart
$HourlyBronze = (Build-AggregateHourly -InputCSV $BronzePSU)

$chart = New-CustomizedChart -ChartTitle "Bronze rated PSU" -YAxisTitle "Watt" -XaxisTitle "Hours Since Start"

# First measurement
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

# Finally save and open
$Chart.SaveImage("Images\Bronze.png", "png")
Start-Process .\Images\Bronze.png
