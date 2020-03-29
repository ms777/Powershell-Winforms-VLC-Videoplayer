function Start-PlayVideoVLC {
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
        [string]$Uri,

        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [string]$title = 'VLC Movie Player'
    )        
    Add-Type -AssemblyName System.Windows.Forms
    $libPath = "C:\users\Martin\Documents\utils\powershell\VLC\"

    $libsPS = ('LibVLCSharp.dll', 'LibVLCSharp.WinForms.dll', 'Microsoft.Threading.Tasks.dll')
    $libsPS | foreach {
        $path = "$($libPath)$($_)"
        try {
            Add-Type -Path $path | Out-Null
        } catch {
            write-Host -ForegroundColor red "WinformsVLC: Could not load $($path)`n$($Error)"
            exit
        } 
    }

    $libVLC = [LibVLCSharp.Shared.LibVLC]::new()

    $media = [LibVLCSharp.Shared.Media]::new($libVLC, $Uri, [LibVLCSharp.Shared.FromType]::FromLocation)
    $player = [LibVLCSharp.Shared.MediaPlayer]::new($media)

    $margin = 10

    $window = [System.Windows.Forms.Form]::new()
    $window.Width = 1000
    $window.Height = 600
    $window.Text = $title
    $window | Add-Member NoteProperty -Name returnString -Value "no button" -Force

    $butSave = [System.Windows.Forms.Button]::new()
    $butSave.Location = [System.Drawing.Point]::new($margin,$window.ClientSize.Height-$margin-$butSave.Height)
    $butSave.Text = "Save"
    $butSave.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left);
    $butSave.Add_Click({
        $window.returnString =  $butSave.Text
        $window.Dispose()
    })
    $window.Controls.Add($butSave)

    $butCancel = [System.Windows.Forms.Button]::new()
    $butCancel.Location = [System.Drawing.Point]::new($butSave.Location.X + $butSave.Width + $margin, $butSave.Location.Y)
    $butCancel.Text = "Cancel"
    $butCancel.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left);
    $butCancel.Add_Click({
        $window.returnString = $butCancel.Text
        $window.Dispose()
    })
    $window.Controls.Add($butCancel)

    $video = [LibVLCSharp.WinForms.VideoView]::new()
    $video.MediaPlayer = $player
    $video.Location = [System.Drawing.Point]::new($margin,$margin)
    $video.Width = $window.ClientSize.Width-2*$margin
    $video.Height = $butCancel.Location.Y-2*$margin
    $video.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right);
    $window.Controls.Add($video)

    $slidePosition = [System.Windows.Forms.TrackBar]::new()
    $slidePosition.Maximum = 100
    $slidePosition.SmallChange = 1
    $slidePosition.LargeChange = 100
    $slidePosition.Location = [System.Drawing.Point]::new($butCancel.Location.X + $butCancel.Width + $margin, $butSave.Location.Y)
    $slidePosition.Width = $window.ClientSize.Width - $slidePosition.Location.X
    $slidePosition.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right);
    $slidePosition.Add_ValueChanged({
    #    Write-Host "slider pos: $($slidePosition.Value), duration: $($player.media.Duration), pos: $($player.Position)"
        $player.Position = $slidePosition.Value*0.01*0.99
    })
    $window.Controls.Add($slidePosition)

    $timer = [System.Windows.Forms.Timer]::new()
    $timer.Interval = 1000
    $timer.add_tick({
    #    write-host "Timer: $(get-date -Format 'HH:mm:ss'), video pos: $($player.Position), slider val: $($slidePosition.Value)"
        $slidePosition.Value = $player.Position * $slidePosition.Maximum
    })
    $player.play() | Out-Null
    $timer.Start()
    [void]$window.ShowDialog()
    $player.Stop()
    $timer.stop()

    $window.returnString
}
