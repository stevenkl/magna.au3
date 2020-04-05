;init.au3
#include-once


Global $g__sMagnaBackendEngine = ""

Func _Magna_Init()
	if $g__sMagnaBackendEngine = "" Then
		ConsoleWrite("Please load a backend for Magna to function properly.")
		Exit 255
	EndIf
	
	_AutoItObject_Startup()
EndFunc