#include <IE.au3>
#include <MsgBoxConstants.au3>
;$CmdLine[0] ; Contains the total number of items in the array.
;$CmdLine[1] ; The first parameter.

Opt("SendKeyDelay", 20)
;$oIE = _IEAttach ("Amano Parking","title")
;$oIE = _IEAttach ("CNN - Breaking News, Latest News and Videos","title")
;MsgBox($MB_SYSTEMMODAL, "The URL", _IEPropertyGet($oIE, "locationurl"))
;$biUrl = "https://" & $CmdLine[1] & ".amanoanalytics.com/reports"
;MsgBox($MB_SYSTEMMODAL, $biUrl, _IEPropertyGet($oIE, "locationurl"))
;_IENavigate($oIE,$biUrl,0)


;MsgBox($MB_SYSTEMMODAL, "Found the window", "")
AutoItSetOption("WinTitleMatchMode","1")
WinWait("Windows Security")
$title = WinGetTitle("Windows Security") ; retrives whole window title
WinActivate($title)
$UN=WinGetText($title,"User name")
;MsgBox($MB_SYSTEMMODAL, "Found the window", $UN)
ControlSend($title,"",$UN,"Chris");Sets Username
ControlSend($title,"",$UN,"{TAB}");Sets Username
;Send("{TAB 1}")
;MsgBox($MB_SYSTEMMODAL, "Sent the username", $UN)
;Send("Secret2020")
;sleep(1000)
$PWD=WinGetText($title,"Password")
;msgBox($MB_SYSTEMMODAL, "The URL", $PWD)
;Send("{TAB 1}")
ControlSend($title,"",$PWD,"ChrisGoodnight01");Sets PWD
;MsgBox($MB_SYSTEMMODAL, "Sent the password", $UN)
;ControlSend($title,"",$UN,"{TAB}");Sets Username
ControlSend($title,"",$UN,"{TAB}");Sets Username
ControlSend($title,"",$PWD,"{ENTER}");Sets PWD


