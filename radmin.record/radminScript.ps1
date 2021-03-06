#Black magik)
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Win32 {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string ClassName, IntPtr  TitleApp);
  }
  public struct RECT
  {
    public int Left;        
    public int Top;         
    public int Right;       
    public int Bottom;      
  }
"@

start "C:\Program Files (x86)\Radmin Viewer 3\Radmin.exe"	#Важный момент, нельзя сворачивать радмин, иначе потеряем идентификатор
start-sleep 5
$h = (Get-Process | where {$_.MainWindowTitle -match "Radmin Viewer"}).MainWindowHandle
$rcWindow = New-Object RECT
[void][Win32]::GetWindowRect($h,[ref]$rcWindow)	#Здесь у нас уже есть hWnd, и само окно

function startRadmin	{
	start "C:\bdCam.instances\radminScript.ps1"	#Дважды hWnd он увы находить не умеет, особенность радмина
	Start-Sleep 60
	if(-not (Get-Process | Where {$_.ProcessName -eq "Radmin"}))
    {
        startRadmin
    }
	exit
}

function tryConnect ($client)	{	#Тупо щёлкает по кнопкам
	$message = Get-Date -Format "HH:mm:ss dd.MM.yyyy"
	if ($client -eq "R1")	{
		$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Radmin Viewer'); Sleep 1; $wshell.SendKeys('{a}')
        Sleep 1
        $wshell.SendKeys('{Enter}')
		$message = "Try to start session with BigBrotherWatch-1 at " + $message
		echo $message
	}
	if ($client -eq "R2")	{
		$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Radmin Viewer'); Sleep 1; $wshell.SendKeys('{b}')
        Sleep 1
        $wshell.SendKeys('{Enter}')
		$message = "Try to start session with BigBrotherWatch-2 at " + $message
		echo $message
	}
	if ($client -eq "R3")	{
		$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Radmin Viewer'); Sleep 1; $wshell.SendKeys('{c}')
        Sleep 1
        $wshell.SendKeys('{Enter}')
		$message = "Try to start session with BigBrotherWatch-3 at " + $message
		echo $message
	}
	if ($client -eq "R4")	{
		$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Radmin Viewer'); Sleep 1; $wshell.SendKeys('{d}')
        Sleep 1
        $wshell.SendKeys('{Enter}')
		$message = "Try to start session with BigBrotherWatch-4 at " + $message
		echo $message
	}
	if ($client -eq "R5")	{
		$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('Radmin Viewer'); Sleep 1; $wshell.SendKeys('{e}')
        Sleep 1
        $wshell.SendKeys('{Enter}')
		$message = "Try to start session with BigBrotherWatch-5 at " + $message
		echo $message
	}
}

function startSession ($client) {	#Передвигает главное окно радмина. Прикол в том, что он разворачивает фулскрин на
    if ($client -eq "R1")	{		#том монике, где было главное окно
		$left = 0
        $top  = -1200
	}
	if ($client -eq "R2")	{
		$left = 1920
        $top  = -120	
	}
	if ($client -eq "R3")	{
		$left = 906
        $top  = 1080
	}
	if ($client -eq "R4")	{
		$left = -695
        $top  = 1081
	}
	if ($client -eq "R5")	{
		$left = -1600
        $top  = -120
	}

    $WndWidth  = 864;
    $WndHeight = 518;
    [void][Win32]::MoveWindow($h, $left, $top, $WndWidth, $WndHeight, $true)
    tryConnect($client)
}

function checkSessions{		#Проверяем наличие стабильного коннекта с клиентом, если нету - поднимаем снова
    $tcp = netstat
    $R1address = "192.168.2.231"
    $R1status = 0
	$R2address = "192.168.2.232"
    $R2status = 0
	$R3address = "192.168.2.233"
    $R3status = 0
	$R4address = "192.168.2.234"
    $R4status = 0
	$R5address = "192.168.2.235"
    $R5status = 0
	
	foreach ($session in $tcp){	#Чекаем наличие соединения, если его нету - поднимаем
    if ($session.Contains($R1address) -and ($session.Contains("ESTABLISHED") -or $session.Contains("SYN_SENT"))) {$R1status=1}
    if ($session.Contains($R2address) -and ($session.Contains("ESTABLISHED") -or $session.Contains("SYN_SENT"))) {$R2status=1}
    if ($session.Contains($R3address) -and ($session.Contains("ESTABLISHED") -or $session.Contains("SYN_SENT"))) {$R3status=1}
    if ($session.Contains($R4address) -and ($session.Contains("ESTABLISHED") -or $session.Contains("SYN_SENT"))) {$R4status=1}
    if ($session.Contains($R5address) -and ($session.Contains("ESTABLISHED") -or $session.Contains("SYN_SENT"))) {$R5status=1}
	}
	
	if ($R1status -eq 0)	{
		startSession("R1")
		Start-sleep 1
	}
	if ($R2status -eq 0)	{
		startSession("R2")
		Start-sleep 1
	}
	if ($R3status -eq 0)	{
		startSession("R3")
		Start-sleep 1
	}
	if ($R4status -eq 0)	{
		startSession("R4")
		Start-sleep 1
	}
	if ($R5status -eq 0)	{
		startSession("R5")
		Start-sleep 1
	}
	
	$WndWidth  = 864	#Положение окна после работы
    $WndHeight = 518
	$left = 633
	$top = 297
    [void][Win32]::MoveWindow($h, $left, $top, $WndWidth, $WndHeight, $true)
	
}

while (1){
    Start-Sleep 5
	if(-not (Get-Process | Where {$_.ProcessName -eq "Radmin"}))
    {
        startRadmin
    }
    checkSessions
}