;utils.au3
#include-once

#Region Helper Functions

Func _Array()
	local $arr = []
	_ArrayDelete($arr, 0)
	return $arr
EndFunc


Func _Dict()
	local $d = ObjCreate("Scripting.Dictionary")
	$d.CompareMode = 1
	return $d
EndFunc

Func _Vector2D($x, $y)
	local $arr = [$x, $y]
	return $arr
EndFunc


Func _Vector3D($x, $y, $z)
	local $arr = [$x, $y, $z]
	return $arr
EndFunc


Func _Color($r, $g, $b)
	return (0x & Hex($r) & Hex($g) & Hex($b))
EndFunc


Func _AlphaColor($a, $r, $g, $b)
	return (0x & Hex($a) & Hex($r) & Hex($g) & Hex($b))
EndFunc

#EndRegion Helper Functions