;*****************************************
;Manga.au3 by Steven Kleist (stevenkl) <kleist.steven@gmail.com>
;Created with ISN AutoIt Studio v. 1.10
;*****************************************
#Region AutoIt-Includes
#include <Array.au3>
#include <Timers.au3>
#include <WinAPISys.au3>
#include <GDIPlus.au3>
#include <GDIPlusConstants.au3>

#EndRegion AutoIt-Includes


#Region Vendor-Includes
#include "vendor\AutoItObject.au3"

#EndRegion Vendor-Includes


#Region Magna-Includes
#include "core\magna_class.au3"
#include "core\init.au3"
#include "utils\collision.au3"
#include "utils\sprite.au3"
#include "utils\utils.au3"

#EndRegion Magna-Includes



;~ Global $MS_PER_UPDATE = 16.666667

Global $hGUI, $g_hContext, $hContext, $hGraphic, $hBitmap
Global $hActiveBuffer = 0
Global $aBitmaps = _Array()
Global $aBuffers = _Array()


Global $g_MEntities = _Array()

Global $magna




#Region Main GameLoop
Func GameLoop($FPS, $fSetup, $fUpdate, $fRender)
	
	local $accumulator = 0
	local $ifps =  $FPS
	local $delta = 1000 / $ifps
	local $step  = 1 / $ifps
	local $last, $now, $dt
	
	_M_MainSetup($fSetup)
	
	While 1
		$now = _WinAPI_GetTickCount()
		$dt = $now - $last
		$last = $now
		if $dt < 1000 then
			$accumulator += $dt
			while $accumulator >= $delta
				_M_MainUpdate($step, $fUpdate)
				$accumulator -= $delta
			Wend
			_M_MainRender($fRender)
;~ 			Sleep(10)

		EndIf

	Wend
EndFunc
#EndRegion Main GameLoop



Func ProcessInput()
	Switch @HotKeyPressed ; The last hotkey pressed.
        Case "{ESC}" ; String is the {ESC} hotkey.
			; Clean up resources
			_Exit()
    EndSwitch
EndFunc






#Region Entities
Func _M_Entities()
	return $g_MEntities
EndFunc


Func _M_AddEntity($e)
	_ArrayAdd($g_MEntities, $e)
	return (UBound($g_MEntities) - 1)
EndFunc


Func _M_GetEntity($iIndex)
	return $g_MEntities[$iIndex]
EndFunc


Func _M_FindEntityByName($sName)
	for $entity in $g_MEntities
		if $entity("name") = $sName Then
			return $entity
		EndIf
	Next
	return false
EndFunc


Func _M_FindEntitiesByType($sType)
	local $arr = _Array()
	for $entity in $g_MEntities
		if $entity("type") = $sType Then
			_ArrayAdd($arr, $entity)
		EndIf
	Next
	return $arr
EndFunc


Func _M_FindEntitiesByProperty($sProperty, $vValue)
	local $arr = _Array()
	for $entity in $g_MEntities
		if $entity($sProperty) = $vValue Then
			_ArrayAdd($arr, $entity)
		EndIf
	Next
	return $arr
EndFunc
#EndRegion Entities




#Region Main-Setup,Update,Render
Func _M_MainSetup($fUserSetup)
	HotKeySet("{ESC}", ProcessInput)
	
    ; Create GUI
    $hGUI = GUICreate($sTitle ? $sTitle : "", $iWidth * $iScale, $iHeight * $iScale)
    GUISetState(@SW_SHOW)

    _GDIPlus_Startup()
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
    _ArrayAdd($aBitmaps, _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphic))
	_ArrayAdd($aBitmaps, _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphic))
	
	for $bitmap in $aBitmaps
		_ArrayAdd($aBuffers, _GDIPlus_ImageGetGraphicsContext($bitmap))
	Next
	
	$hContext = $aBuffers[$hActiveBuffer]
	
	$fUserSetup()
EndFunc


Func _M_MainUpdate($step, $fUserUpdate)
	
	
	$fUserUpdate($step)
EndFunc


Func _M_MainRender($fUserRender)
	_GDIPlus_GraphicsClear($hContext, 0xFFFFFFFF)
	
	$fUserRender($hContext)
	
	if $DEBUG then
		_M_DebugRender()
	EndIf
	
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $aBitmaps[$hActiveBuffer] , 0, 0, $iWidth * $iScale, $iHeight * $iScale)
	If $hActiveBuffer = 1 Then
		$hActiveBuffer = 0
	Else 
		$hActiveBuffer = 1
	EndIf
	$hContext = $aBuffers[$hActiveBuffer]
EndFunc
#EndRegion Main-Setup,Update,Render



Func _M_DebugRender()
	
	local $pen = _GDIPlus_PenCreate(0x55000000, 1, 2)
	
	for $i = 0 to $iHeight Step $iRasterX
		_GDIPlus_GraphicsDrawLine($hContext, 0, $i, $iWidth, $i, $pen)
	Next
	for $i = 0 to $iWidth Step $iRasterY
		_GDIPlus_GraphicsDrawLine($hContext, $i, 0, $i, $iHeight, $pen)
	Next
EndFunc



Func _Exit()
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_GraphicsDispose($hContext)
	for $bitmap in $aBitmaps
		_GDIPlus_BitmapDispose($bitmap)
	Next
	_GDIPlus_Shutdown()
	Exit
	
EndFunc