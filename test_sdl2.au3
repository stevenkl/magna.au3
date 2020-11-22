;test_sdl2.au3
Opt("GuiOnEventMode", 1)
#include <Array.au3>

Global Const $DEBUG = False 
Global Const $hSDLDLL = DllOpen(@ScriptDir & "\lib\SDL2.dll")
If $hSDLDLL = -1 Then
	ConsoleWrite("Error opening SDL2.dll!" & @CRLF)
	Exit
EndIf



#Region Defines
Global Const $SDL_INIT_TIMER          = 0x00000001
Global Const $SDL_INIT_AUDIO          = 0x00000010
Global Const $SDL_INIT_VIDEO          = 0x00000020
Global Const $SDL_INIT_JOYSTICK       = 0x00000200
Global Const $SDL_INIT_HAPTIC         = 0x00001000
Global Const $SDL_INIT_GAMECONTROLLER = 0x00002000
Global Const $SDL_INIT_EVENTS         = 0x00004000
Global Const $SDL_INIT_SENSOR         = 0x00008000
Global Const $SDL_INIT_NOPARACHUTE    = 0x00100000
Global Const $SDL_INIT_EVERYTHING     = BitOR(	$SDL_INIT_TIMER, _
												$SDL_INIT_AUDIO, _
												$SDL_INIT_VIDEO, _
												$SDL_INIT_JOYSTICK, _
												$SDL_INIT_HAPTIC, _
												$SDL_INIT_GAMECONTROLLER, _
												$SDL_INIT_EVENTS, _
												$SDL_INIT_SENSOR, _
												$SDL_INIT_NOPARACHUTE)
#EndRegion Defines

Global Const $__tagSDL_version = "STRUCT;ubyte major;ubyte minor;ubyte patch;ENDSTRUCT"

#Region _SDL_GetVersion
Func _SDL_GetVersion()
	local $tVersion = DllStructCreate($__tagSDL_version)
	local $result = DllCall($hSDLDLL, "none:cdecl", "SDL_GetVersion", _
		"ptr", DllStructGetPtr($tVersion) _
	)
	If @error Or VarGetType($result) <> "Array" Then
		Return SetError(@error, @extended, False)
	EndIf
	Return $tVersion
EndFunc
#EndRegion _SDL_GetVersion

#Region _SDL_Init
Func _SDL_Init($iFlags)
	local $result = DllCall($hSDLDLL, "none:cdecl", "SDL_Init", _
		"uint", $iFlags _
	)
	If @error Or VarGetType($result) <> "Array" Then
		Return SetError(@error, @extended, False)
	EndIf
	Return $result[0]
EndFunc
#EndRegion _SDL_Init

#Region _SDL_GetError
Func _SDL_GetError()
	local $result = DllCall($hSDLDLL, "str:cdecl", "SDL_GetError")
	If @error Or VarGetType($result) <> "Array" Then
		Return SetError(@error, @extended, False)
	EndIf
	Return $result[0]
EndFunc
#EndRegion _SDL_GetError

#Region _SDL_CreateWindow
Func _SDL_CreateWindow($sTitle, $iX, $iY, $iWidth, $iHeight, $iFlags = 0)
	
EndFunc
#EndRegion _SDL_CreateWindow






#Test _SDL_GetVersion
local $ver = _SDL_GetVersion()
If @error Then
	ConsoleWrite(StringFormat( _
		"[_SDL_GetVersion] @error = %d, @extended = %d", _
		@error, _
		@extended _
	) & @CRLF)
	Exit
Else
	ConsoleWrite(StringFormat( _
		"[_SDL_GetVersion] SDL2 v.%d.%d.%d", _
		$ver.major, _
		$ver.minor, _
		$ver.patch _
	) & @CRLF)
EndIf
#EndTest _SDL_GetVersion


#Test _SDL_Init
local $_SDL_Init_Result = _SDL_Init($SDL_INIT_AUDIO)
local $err = _SDL_GetError()
ConsoleWrite($err & @CrLF)
If @error Then
	ConsoleWrite(StringFormat( _
		"[_SDL_Init] @error = %d, @extended = %d", _
		@error, _
		@extended _
	) & @CRLF)
	Exit
Else
	ConsoleWrite(StringFormat( _
		"[_SDL_Init] Result =  %d", _
		$_SDL_Init_Result _
	) & @CRLF)
EndIf
#EndTest _SDL_Init