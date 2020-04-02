;collision.au3
#include-once

; Collision detection with 2 rectangles
; https://www.youtube.com/watch?v=U1iAY0gNFtE&list=PLDA308F5DD6606CFC&index=15&t=0s
Func _Collide_Rect(ByRef $a, ByRef $b)
	local $aLeft = $a("x"), _
		$aRight = ($a("x") + $a("width")), _
		$aTop = $a("y"), _
		$aBottom = ($a("y") + $a("height"))
	
	local $bLeft = $b("x"), _
		$bRight = ($b("x") + $b("width")), _
		$bTop = $b("y"), _
		$bBottom = ($b("y") + $b("height"))
	
	if 	($aLeft < $bRight) And _
		($bLeft < $aRight) And _
		($aTop < $bBottom) And _
		($bTop < $aBottom) _
	then
		return true
	EndIf
	return false
EndFunc



Func _Collide_Circle(ByRef $a, ByRef $b)
	local $x = $b("width") - $a("width")
	local $y = $b("height") - $a("height")
	local $hyp = Sqrt(($x^2) + ($y^2))
	return $hyp < ($a("radius") + $b("radius"))
EndFunc



Func _Collide_RectContainsCircleDot(ByRef $rect, ByRef $circle)
	; Helper variables for the rectangle
	local $rectLeft   = $rect("x")
	local $rectRight  = ($rect("x") + $rect("width"))
	local $rectTop    = $rect("y")
	local $rectBottom = ($rect("y") + $rect("height"))
	
	
	; 1. Circle center is in the rectangle
	#cs
		$cirlce.x < $rectLeft And
		$circle.x > $rectRight And
		$circle.y < $rectBottom And
		$circle.y > $rectTop
	#ce
	If 	($circle("x") < $rectLeft) And _
		($circle("x") > $rectRight) And _
		($circle("y") < $rectBottom) And _
		($circle("y") > $rectTop) _
	Then
		Return True
	EndIf
	
	Return False
EndFunc



Func _Collide_CircleOnRectEdges(ByRef $rect, ByRef $circle)
	; Helper variables for the rectangle
	local $rectLeft   = $rect("x")
	local $rectRight  = ($rect("x") + $rect("width"))
	local $rectTop    = $rect("y")
	local $rectBottom = ($rect("y") + $rect("height"))
	
	
	; 2. One of edges of the rectangle are inside the circle
	#cs
		$p1 = [$rectLeft, $rectTop]
		$p2 = [$rectRight, $rectTop]
		$p3 = [$rectRight, $rectBottom]
		$p4 = [$rectLeft, $rectBottom]
		
		Pytharogas with each point and the circle
	#ce
	local $hyp1 = Sqrt(($rectLeft^2) + ($rectTop^2))
	If $hyp1 < $circle("radius") Then
		Return True
	EndIf
	
	local $hyp2 = Sqrt(($rectRight^2) + ($rectTop^2))
	If $hyp2 < $circle("radius") Then
		Return True
	EndIf
	
	local $hyp3 = Sqrt(($rectRight^2) + ($rectBottom^2))
	If $hyp3 < $circle("radius") Then
		Return True
	EndIf
	
	local $hyp4 = Sqrt(($rectLeft^2) + ($rectBottom^2))
	If $hyp4 < $circle("radius") Then
		Return True
	EndIf
	
	return false
EndFunc


Func _Collide_CircleOnRectSides($rect, $circle)
	; Helper variables for the rectangle
	local $rectLeft   = $rect("x")
	local $rectRight  = ($rect("x") + $rect("width"))
	local $rectTop    = $rect("y")
	local $rectBottom = ($rect("y") + $rect("height"))
	
	
	; 3. The circle overlappes on of the rectangle sides
	#cs
		4 virtual rectangles for each side, do nr. 1. on it.
	#ce
	
	; Left virtual rect
	local $rect1 = _Dict()
	$rect1.Add("x", ($rectLeft - $circle("radius")))
	$rect1.Add("y", $rectTop)
	$rect1.Add("width", ($rect1("x") + $circle("radius")*2))
	$rect1.Add("height", ($rectBottom - $rectTop))
	if _Collide_RectContainsCircleDot($rect1, $circle) then return true
	
	; Top virtual rect
	local $rect2 = _Dict()
	$rect2.Add("x", $rectLeft)
	$rect2.Add("y", ($rectTop - $circle("radius")))
	$rect2.Add("width", ($rectRight - $rectLeft))
	$rect2.Add("height", $rect2("y") + $circle("radius")*2))
	if _Collide_RectContainsCircleDot($rect2, $circle) then return true
	
	; Right virtual rect
	local $rect3 = _Dict()
	$rect3.Add("x", ($rectRight - $circle("radius")))
	$rect3.Add("y", $rectTop)
	$rect3.Add("width", ($rect3("x") + $circle("radius")*2))
	$rect3.Add("height", ($rectBottom - $rectTop))
	if _Collide_RectContainsCircleDot($rect3, $circle) then return true
	
	; Bottom virtual rect
	local $rect4 = _Dict()
	$rect4.Add("x", $rectLeft)
	$rect4.Add("y", ($rectBottom - $circle("radius")))
	$rect4.Add("width", ($rectRight - $rectLeft))
	$rect4.Add("height", ($rect4("y") + $circle("radius")*2))
	if _Collide_RectContainsCircleDot($rect4, $circle) then return true
	
	return false
EndFunc



Func _Collide_RectCircle(ByRef $rect, ByRef $circle)
	
	if _Collide_RectContainsCircleDot($rect, $circle) then return true
	if _Collide_CircleOnRectEdges($rect, $circle) then return true
	if _Collide_CircleOnRectSides($rect, $circle) then return true
	
	return false
EndFunc



