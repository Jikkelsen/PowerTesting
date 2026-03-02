Add-Type -AssemblyName System.Windows.Forms.Datavisualization

# Setup
$Chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width  = 1600
$Chart.Height = 900

# Fonts
$TitleFont   = New-Object System.Drawing.Font("Courier", 22, [System.Drawing.FontStyle]::Bold)
$GeneralFont = New-Object System.Drawing.Font("Courier", 16, [System.Drawing.FontStyle]::Bold)
$LegendFont  = New-Object System.Drawing.Font("Courier", 14, [System.Drawing.FontStyle]::Bold)

# ChartArea
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$ChartArea.AxisX.MajorGrid.LineColor = [System.Drawing.Color]::LightGray
$ChartArea.AxisY.MajorGrid.LineColor = [System.Drawing.Color]::LightGray
$ChartArea.AxisX.Title = "Hour"
$ChartArea.AxisY.Title = "Watts"
$ChartArea.AxisX.TitleFont = $GeneralFont
$ChartArea.Axisy.TitleFont = $GeneralFont

$Chart.ChartAreas.Add($ChartArea)

# Titles
$Title      = $chart.Titles.Add("PSU Power Testing")
$Title.Font = $TitleFont

# First measurement
$Bronze             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Bronze.Name        = "Bronze"
$Bronze.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Bronze.BorderWidth = 3
$Bronze.Points.AddXY(2,3)
$Bronze.Points.AddXY(3,5)
$Bronze.Points.AddXY(4,7)
$Chart.Series.Add($Bronze)

# Second Measurement
$Gold             = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Gold.Name        = "Gold"
$Gold.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Gold.BorderWidth = 3
$Gold.Points.AddXY(2,5)
$Gold.Points.AddXY(3,10)
$Gold.Points.AddXY(4,15)
$Chart.Series.Add($Gold)

# Legends
$Legend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
$Legend.Position.Auto = $False
$Legend.Position.X = 15
$Legend.Position.Y = 0
$Legend.Position.Width = 25
$Legend.Position.Height = 20
$Legend.BackColor = [System.Drawing.Color]::Transparent
$Legend.BorderColor = [System.Drawing.Color]::Transparent
$Legend.Font = $LegendFont

$Chart.Legends.Add($Legend)

$Chart.SaveImage("chart.png", "png")
Start-Process Chart.Png

