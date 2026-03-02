function New-CustomizedChart 
{
    [CmdletBinding()]
    param 
    (
        [Parameter()]
        [String]
        $ChartTitle,

        [Parameter()]
        [String]
        $YAxisTitle,

        [Parameter()]
        [String]
        $XaxisTitle
    )

    # Adding Type is important
    Add-Type -AssemblyName System.Windows.Forms.Datavisualization

    # Setup
    $Chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $Chart.Width  = 1600
    $Chart.Height = 900

    # Fonts
    $TitleFont   = New-Object System.Drawing.Font("Courier", 22, [System.Drawing.FontStyle]::Bold)
    $GeneralFont = New-Object System.Drawing.Font("Courier", 16, [System.Drawing.FontStyle]::Bold)
    $LegendFont  = New-Object System.Drawing.Font("Courier", 8, [System.Drawing.FontStyle]::Bold)

    # ChartArea
    $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $ChartArea.AxisX.MajorGrid.LineColor = [System.Drawing.Color]::LightGray
    $ChartArea.AxisY.MajorGrid.LineColor = [System.Drawing.Color]::LightGray
    $ChartArea.AxisX.Title = $XaxisTitle
    $ChartArea.AxisY.Title = $YAxisTitle
    $ChartArea.AxisX.TitleFont = $GeneralFont
    $ChartArea.Axisy.TitleFont = $GeneralFont

    $Chart.ChartAreas.Add($ChartArea)

    # Titles
    $Title      = $chart.Titles.Add($ChartTitle)
    $Title.Font = $TitleFont

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

    Return $Chart
   }