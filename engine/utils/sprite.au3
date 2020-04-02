;sprite.au3
#include-once


Func _M_NewSprite($sName, $sImagePath, $x, $y)
	
	If Not FileExists($sImagePath) Then
		ConsoleWrite(StringFormat("Error: image %s not found.", $sImagePath) & @CRLF)
		return SetError(1)
	EndIf
	
	local $d = _Dict()
	$d.Add("name", $sName)
	$d.Add("type", "sprite")
	$d.Add("x", $x)
	$d.Add("y", $y)
	$d.Add("vx", 0)
	$d.Add("vy", 0)
	$d.Add("dx", 0)
	$d.Add("dy", 0)
	
	$d.Add("image", _GDIPlus_ImageLoadFromFile($sImagePath))
	$d.Add("width", _GDIPlus_ImageGetWidth($d("image")))
	$d.Add("height", _GDIPlus_ImageGetHeight($d("image")))
	
	return $d
EndFunc



Func _M_NewSpriteSheet($sImage, $iFrameWidth, $iFrameHeight)
	
EndFunc