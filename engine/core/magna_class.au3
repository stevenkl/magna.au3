;magna_class.au3
#include-once


Func _Magna_Class__New($arg1)
	local $class = _AutoItObject_Class()
	$class.AddProperty("name", $ELSCOPE_READONLY, $arg1)
	Return $class.Object
EndFunc