#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "engine\Magna.au3"
#include "engine\backend\default.au3"
#include "config.au3"


Main()


#Region Setup, Update, Render
Func Setup()
	For $i = 1 To 25
		; Creating objects
		local $it = _Dict()
		local $width = Random(10, 40, 1), $height = Random(10, 40, 1)
		local $color = $aColors[Random(0, UBound($aColors) - 1, 1)]
		$it.Add("name", StringFormat("rect_%d", $i))
		$it.Add("type", "rectangle")
		$it.Add("x", Random(20, $iWidth - $width, 1))
		$it.Add("y", Random(20, $iHeight - $height, 1))
		$it.Add("vx", Random(2, 5))
		$it.Add("vy", Random(2, 5))
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
		$it.Add("vx", Random(2, 5))
		$it.Add("vy", Random(2, 5))
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
	
;~ 	for $i = 0 to UBound($g_MEntities) - 1
;~ 		for $j = 0 to UBound($g_MEntities) - 1
;~ 			if $i <> $j then
;~ 				if _Collide_Rect($g_MEntities[$i], $g_MEntities[$j]) = true then
;~ 					$g_MEntities[$i]("color") = 0xFF000000
;~ 					$g_MEntities[$j]("color") = 0xFF000000
;~ 				Else
;~ 					$g_MEntities[$i]("color") = $g_MEntities[$i]("defaultcolor")
;~ 					$g_MEntities[$j]("color") = $g_MEntities[$j]("defaultcolor")
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	Next
	
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
EndFunc


Func Render(ByRef $context)
	
	local $brush = _GDIPlus_BrushCreateSolid()
	
	for $item in _M_Entities()
		
		if $item("type") = "sprite" Then
			_GDIPlus_GraphicsDrawImage($context, $item("image"), $item("x"), $item("y"))
		Else
			_GDIPlus_BrushSetSolidColor($brush, $item("color"))
			_GDIPlus_GraphicsFillRect($context, $item("x"), $item("y"), $item("width"), $item("height"), $brush)
		EndIf
	Next
	
	_GDIPlus_BrushDispose($brush)
	
EndFunc

#EndRegion Setup, Update, Render


#Region Main Function
Func Main()
	_Magna_Init()
	GameLoop(60, Setup, Update, Render)
EndFunc
#EndRegion Main Function

