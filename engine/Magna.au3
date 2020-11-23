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

#include <GUIConstantsEx.au3>
#include <WinAPIGdi.au3>
#include <WinAPIGdiDC.au3>
#include <WinAPIHObj.au3>
#include <WindowsConstants.au3>

#EndRegion AutoIt-Includes


#Region Vendor-Includes
#include "vendor\AutoItObject.au3"

#EndRegion Vendor-Includes


#Region Magna-Includes
#include "core\magna.class.au3"
#include "core\init.au3"
#include "utils\collision.au3"
#include "utils\sprite.au3"
#include "utils\utils.au3"

#EndRegion Magna-Includes



Global $MS_PER_UPDATE = 16.666667

Global $hGUI, $g_hContext, $hContext, $hGraphic, $hBitmap, $hBuffer
Global $hDC, $hDC_Backbuffer, $oDC_Obj, $hGfxCtx
Global $hActiveBuffer = 0
Global $dSwapIntervall = 0.0
Global $aBitmaps = _Array()
Global $aBuffers = _Array()


Global $g_MEntities = _Array()

Global $magna




#Region Main GameLoop
Func GameLoop($FPS, $fSetup, $fUpdate, $fRender)
	
	local $accumulator = 0
	local $ifps =  $FPS
	local $delta = 1000 / $ifps
	local $step  = 1.0 / $ifps
	local $last, $now, $dt
	
	_M_MainSetup($fSetup)
	
	
	Local $dStart = 0
	Do
		$dStart = TimerInit()
		_M_MainUpdate($step, $fUpdate)
		_M_MainRender($step, $fRender)
	Until Not Sleep( (1000.0 / $FPS) - TimerDiff($dStart))
	
	
;~ 	While 1
;~ 		If Not $bPause Then
;~ 			$now = _WinAPI_GetTickCount()
;~ 			$dt = $now - $last
;~ 			$last = $now
;~ 			if $dt < 1000 then
;~ 				$accumulator += $dt
;~ 				while $accumulator >= $delta
;~ 					_M_MainUpdate($step, $fUpdate)
;~ 					$accumulator -= $delta
;~ 				Wend
;~ 				_M_MainRender($step, $fRender)
;~ 			EndIf
;~ 		
;~ 		Else
;~ 			Sleep(10)
;~ 		EndIf
;~ 
;~ 	Wend


;~ 	Do
;~ 		_M_MainUpdate($step, $fUpdate)
;~ 		_M_MainRender($step, $fRender)
;~ 	Until Not Sleep(1000/$FPS)


;~ 	While 1
;~ 		If Not $bPause Then
;~ 			_M_MainUpdate($step, $fUpdate)
;~ 			_M_MainRender($step, $fRender)
;~ 			Sleep(1000 / $FPS)
;~ 		EndIf
;~ 	Wend


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
	
;~ 	for $entity in $g_MEntities
;~ 		if $entity("type") = $sType Then
;~ 			_ArrayAdd($arr, $entity)
;~ 		EndIf
;~ 	Next
	
	For $i = 0 To UBound($g_MEntities) - 1
		if ($g_MEntities[$i]).Item("type") = $sType Then
			_ArrayAdd($arr, $g_MEntities[$i])
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
	
    ; Create GUI
    $hGUI = GUICreate($sTitle ? $sTitle : "", $iWidth , $iHeight )
    GUISetState(@SW_SHOW)

    _GDIPlus_Startup()	
	
	; "C:\Program Files (x86)\AutoIt3\Examples\Helpfile\_WinAPI_BitBlt.au3"
	Local $hBmp = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBmp)
	_GDIPlus_BitmapDispose($hBmp)
	
	$hDC = _WinAPI_GetDC($hGUI)
	$hDC_Backbuffer = _WinAPI_CreateCompatibleDC($hDC)
	$oDC_Obj = _WinAPI_SelectObject($hDC_Backbuffer, $hBitmap)
	$hGfxCtx = _GDIPlus_GraphicsCreateFromHDC($hDC_Backbuffer)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtx, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfxCtx, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)
	
	Global $iRound = 0
	
	$fUserSetup()
EndFunc


Func _M_MainUpdate($step, $fUserUpdate)
	$fUserUpdate($step)
EndFunc


Func _M_MainRender($step, $fUserRender)
		
	_GDIPlus_GraphicsClear($hGfxCtx, 0xFFFFFFFF)
	
	$fUserRender($hGfxCtx)
	
	if $DEBUG then
		_M_DebugRender($hGfxCtx)
	EndIf
	
	If $iRound Then _WinAPI_BitBlt($hDC, 0, 0, $iWidth, $iHeight, $hDC_Backbuffer, 0, 0, $SRCCOPY) ;copy backbuffer to screen (GUI)
	$iRound += 1
	
	
EndFunc
#EndRegion Main-Setup,Update,Render



Func _M_DebugRender(ByRef $ctx)
	
	local $pen = _GDIPlus_PenCreate(0x55000000, 1, 2)
	
	for $i = 0 to $iHeight Step $iRasterX
		_GDIPlus_GraphicsDrawLine($ctx, 0, $i, $iWidth, $i, $pen)
	Next
	for $i = 0 to $iWidth Step $iRasterY
		_GDIPlus_GraphicsDrawLine($ctx, $i, 0, $i, $iHeight, $pen)
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