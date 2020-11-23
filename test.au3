#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "engine\Magna.au3"
#include "engine\backend\default.au3"
;~ #include "engine\backend\sdl2.au3"
#include "config.au3"


Main()


Func WindowEvent()
	Select
	
		Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
			Global $bPause = True
		Case @GUI_CtrlId = $GUI_EVENT_RESTORE
			Global $bPause = False
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			_Exit()

	EndSelect
EndFunc


#Region Setup, Update, Render
Func Setup()
	
	Opt("GUIOnEventMode", 1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "WindowEvent")
    GUISetOnEvent($GUI_EVENT_MINIMIZE, "WindowEvent")
    GUISetOnEvent($GUI_EVENT_RESTORE, "WindowEvent")
	Global $bPause = False
	
	For $i = 1 To 25
		; Creating objects
		local $it = _Dict()
		local $width = Random(20, 80, 1), $height = Random(20, 80, 1)
		local $color = $aColors[Random(0, UBound($aColors) - 1, 1)]
		$it.Add("name", StringFormat("rect_%d", $i))
		$it.Add("type", "rectangle")
		$it.Add("x", Random(20, $iWidth - $width, 1))
		$it.Add("y", Random(20, $iHeight - $height, 1))
		$it.Add("vx", Random(3, 10))
		$it.Add("vy", Random(3, 10))
		$it.Add("width", $width)
		$it.Add("height", $height)
		$it.Add("color", $color)
		$it.Add("defaultcolor", $color)
		$it.Add("active", true)
		_M_AddEntity($it)
	Next
	
	For $i = 1 To 50
		; Creating objects
		local $it = _Dict()
		local $width = 20, $height = 20
		local $color = $aColors[Random(0, UBound($aColors) - 1, 1)]
		$it.Add("name", StringFormat("cube_%d", $i))
		$it.Add("type", "cube")
		$it.Add("x", Random(20, $iWidth - $width, 1))
		$it.Add("y", Random(20, $iHeight - $height, 1))
		$it.Add("vx", Random(5, 10))
		$it.Add("vy", Random(5, 10))
		$it.Add("width", $width)
		$it.Add("height", $height)
		$it.Add("color", $color)
		$it.Add("defaultcolor", $color)
		$it.Add("active", true)
		_M_AddEntity($it)
	Next
	
;~ 	local $it = _M_NewSprite("hero", ".\assets\char1.jpg", 16, 16)
;~ 	_M_AddEntity($it)
	
EndFunc


Func Update($step)
	
		
	If Not $bPause Then
		for $item in _M_Entities()
			
			; check wall
			if ($item("x") < 0) Or (($item("x") + $item("width")) > $iWidth ) then
				$item("vx") = -$item("vx")
			EndIf
			if ($item("y") < 0) Or (($item("y") + $item("height")) > $iHeight) then
				$item("vy") = -$item("vy")
			EndIf
			
			; move
			$item("x") = ($item("x") + $item("vx"))
			$item("y") = ($item("y") + $item("vy"))
		Next
	EndIf
	
EndFunc


Func Render(ByRef $context)
	
;~ 	local $brush = _GDIPlus_BrushCreateSolid()
	
	
	If Not $bPause Then
		For $item in _M_FindEntitiesByType("cube")
			local $brush = _GDIPlus_BrushCreateSolid()
			_GDIPlus_BrushSetSolidColor($brush, $item("color"))
			_GDIPlus_GraphicsFillRect($context, $item("x"), $item("y"), $item("width"), $item("height"), $brush)
			_GDIPlus_BrushDispose($brush)
		Next
		
		For $item in _M_FindEntitiesByType("rectangle")
			local $brush = _GDIPlus_BrushCreateSolid()
			_GDIPlus_BrushSetSolidColor($brush, $item("color"))
			_GDIPlus_GraphicsFillRect($context, $item("x"), $item("y"), $item("width"), $item("height"), $brush)
			_GDIPlus_BrushDispose($brush)
		Next
		
		For $item in _M_FindEntitiesByType("sprite")
			local $brush = _GDIPlus_BrushCreateSolid()
			_GDIPlus_GraphicsDrawImage($context, $item("image"), $item("x"), $item("y"))
			_GDIPlus_BrushDispose($brush)
		Next
	EndIf
	
;~ 	_GDIPlus_BrushDispose($brush)
	
EndFunc

#EndRegion Setup, Update, Render


#Region Main Function
Func Main()
;~ 	_Magna_Init()
;~ 	ConsoleWrite(StringFormat("Typeof $magna: %s", VarGetType($magna)) & @CRLF)
;~ 	ConsoleWrite(StringFormat("$magna.name = %s", $magna.name) & @CRLF)
;~ 	exit
	GameLoop(30.0, Setup, Update, Render)
EndFunc
#EndRegion Main Function

