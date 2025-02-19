Set shell = CreateObject("WScript.Shell")
' Launch the prank on primary display only
shell.Run "mshta.exe ""C:\Windows\Temp\lockscreen.hta""", 1, False
