;test_glfw.au3
Opt("GuiOnEventMode", 1)
#include <Array.au3>

Global Const $DEBUG = False 

; DllOpen
Global $glfw_dll = DllOpen(@ScriptDir &  "\lib\glfw3.dll")
if @error then
	ConsoleWrite(StringFormat("[DllOpen] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
	Exit
EndIf


; glfwInit()
$glfwInit_Result = DllCall($glfw_dll, "int:cdecl", "glfwInit")
if @error then
	ConsoleWrite(StringFormat("[DllCall::glfwInit] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
	Exit
EndIf
If $DEBUG Then _arrayDisplay($glfwInit_Result, "glfwInit")


; glfwCreateWindow(640, 480, "Hello World", NULL, NULL)
Global $glfwCreateWindow_Result = DllCall($glfw_dll, "ptr:cdecl", "glfwCreateWindow", _
	"int", 640, _
	"int", 480, _
	"str", "Hello World", _
	"ptr", Null, _
	"ptr", NULL _
)
if @error then
	ConsoleWrite(StringFormat("[DllCall::glfwCreateWindow] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
	Exit
EndIf
If $DEBUG Then _ArrayDisplay($glfwCreateWindow_Result)


; glfwMakeContextCurrent($glfwCreateWindow_Result[0])
Global $glfwMakeContextCurrent_Result = DllCall($glfw_dll, "none:cdecl", "glfwMakeContextCurrent", _
	"ptr", $glfwCreateWindow_Result[0] _
)
if @error then
	ConsoleWrite(StringFormat("[DllCall::glfwMakeContextCurrent] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
	Exit
EndIf
If $DEBUG Then _ArrayDisplay($glfwMakeContextCurrent_Result, "glfwMakeContextCurrent")



#Region glfwWindowShouldClose
Func glfwWindowShouldClose(ByRef $hWindow)
	local $ret = DllCall($glfw_dll, "int:cdecl", "glfwWindowShouldClose", "ptr", $hWindow)
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwWindowShouldClose] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return $ret[0]
EndFunc
#EndRegion glfwWindowShouldClose
#Region glfwSwapBuffers
Func glfwSwapBuffers(ByRef $hWindow)
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwSwapBuffers", "ptr", $hWindow)
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwSwapBuffers] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwSwapBuffers

#Region glfwPollEvents
Func glfwPollEvents()
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwPollEvents")
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwPollEvents] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwPollEvents

#Region glfwWaitEvents
Func glfwWaitEvents()
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwWaitEvents")
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwWaitEvents] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwWaitEvents

#Region glfwWaitEventsTimeout
Func glfwWaitEventsTimeout($dTimeout)
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwWaitEventsTimeout", _
		"double", $dTimeout _
	)
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwWaitEventsTimeout] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwWaitEventsTimeout

#Region glfwTerminate
Func glfwTerminate()
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwTerminate")
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwTerminate] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwTerminate
#Region glfwSetWindowShouldClose
Func glfwSetWindowShouldClose(ByRef $hWindow, $i)
	local $ret = DllCall($glfw_dll, "none:cdecl", "glfwSetWindowShouldClose", _
	"ptr", $hWindow, _
	"int", $i _
	)
	If @error Then
		ConsoleWrite(StringFormat("[DllCall::glfwSetWindowShouldClose] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
		Return SetError(@error,  @extended)
	EndIf
	Return True
EndFunc
#EndRegion glfwSetWindowShouldClose

; =============================================================================
; =============================================================================
; key_callback(GLFWwindow* window, int key, int scancode, int action, int mods)
Volatile Func _InputCallback($hWindow, $iKey, $iScancode, $iAction, $iMods)
	ConsoleWrite(StringFormat("Key: %d, Scancode: %d, Action: %d, Mods: %d", $iKey, $iScancode, $iAction, $iMods) & @CRLF)
	If $iKey = 256 And $iAction = 1 Then 
		glfwSetWindowShouldClose($hWindow, 1)
	EndIf
EndFunc


Global $callback = DllCallbackRegister("_InputCallback", "none", "ptr;int;int;int;int")
; glfwSetKeyCallback($glfwCreateWindow_Result[0], $callback)
Global $glfwMakeContextCurrent_Result = DllCall($glfw_dll, "none:cdecl", "glfwSetKeyCallback", _
	"ptr", $glfwCreateWindow_Result[0], _
	"ptr", DllCallbackGetPtr($callback) _
)
if @error then
	ConsoleWrite(StringFormat("[DllCall::glfwSetKeyCallback] @error: %d, @extended: %d", @error, @extended) &  @CRLF)
	Exit
EndIf
If $DEBUG Then _ArrayDisplay($glfwMakeContextCurrent_Result, "glfwSetKeyCallback")






While Not glfwWindowShouldClose($glfwCreateWindow_Result[0])
	glfwSwapBuffers($glfwCreateWindow_Result[0])
	glfwWaitEvents()
	
Wend



; Exit
glfwTerminate()
Exit 