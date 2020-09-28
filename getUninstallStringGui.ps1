<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    getUninstall
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(705,400)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$AppTextBox                      = New-Object system.Windows.Forms.TextBox
$AppTextBox.multiline            = $false
$AppTextBox.width                = 213
$AppTextBox.height               = 20
$AppTextBox.location             = New-Object System.Drawing.Point(21,66)
$AppTextBox.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$SearchButton                    = New-Object system.Windows.Forms.Button
$SearchButton.text               = "Search"
$SearchButton.width              = 60
$SearchButton.height             = 30
$SearchButton.location           = New-Object System.Drawing.Point(21,109)
$SearchButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ClearButton                     = New-Object system.Windows.Forms.Button
$ClearButton.text                = "Clear"
$ClearButton.width               = 60
$ClearButton.height              = 30
$ClearButton.location            = New-Object System.Drawing.Point(174,109)
$ClearButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ResultDataGridView              = New-Object system.Windows.Forms.DataGridView
$ResultDataGridView.width        = 402
$ResultDataGridView.height       = 358
$ResultDataGridView.Anchor       = 'top,right,bottom,left'
$ResultDataGridView.location     = New-Object System.Drawing.Point(270,18)

# DataGridView
$Form.Controls.Add($dataGridView)
$ResultDataGridView.ColumnCount = 3
$ResultDataGridView.ColumnHeadersVisible = $true
$ResultDataGridView.Columns[0].Name = "DisplayName"
$ResultDataGridView.Columns[1].Name = "UninstallString"
$ResultDataGridView.Columns[2].Name = "Reg Path"
$ResultDataGridView.AutoSizeColumnsMode = 'Fill'

$Form.controls.AddRange(@($AppTextBox,$SearchButton,$ClearButton,$ResultDataGridView))

$SearchButton.Add_Click({ getData })
$ClearButton.Add_Click({ clearDataGridView })


#Write your logic code here

# Reg Keys
$RegKeys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
)

function getData {
    $app = $AppTextBox.Text
    $Result = $RegKeys | Get-ChildItem | Get-ItemProperty | Where-Object {$_.DisplayName -like "*$app*"}
    
    foreach ($item in $Result) {
    # If DisplayName and UninstallString true
    if ($item.DisplayName -and $item.UninstallString) {

        #$item.DisplayName                                           # DisplayName
        #$item.UninstallString                                       # Uninstallstring
        #$item.PSPath.Split("::")[-1]                                # Reg Path
        
        # DataGridView 
        $ResultDataGridView.Rows.Add($item.DisplayName,$item.UninstallString,$item.PSPath.Split("::")[-1])
    }

}
}



function clearDataGridView {

    # DataGridView Clear
    $ResultDataGridView.Rows.Clear()

    # Textbox Clear
    $AppTextBox.Clear()

    }


# End logic Code
[void]$Form.ShowDialog()