;magna_class.au3
#include-once

#class Name=Magna

#class constructor
Func _Magna_class__New($arg1)
	local $class = _AutoItObject_Class()
	$class.AddProperty("name", $ELSCOPE_READONLY, $arg1)
	
	$class.AddProperty("SceneManager", $ELSCOPE_READONLY, _SceneManager_class__New())
	$class.AddProperty("AssetManager", $ELSCOPE_READONLY, _AssetManager_class__New())
	$class.AddProperty("EntityManager", $ELSCOPE_READONLY, _EntityManager_class__New())
	
	$class.AddProperty("GameLoop", $ELSCOPE_READONLY, _GameLoop_class__New())
	
	$class.AddProperty("Renderer", $ELSCOPE_READONLY, _Renderer_class__New())
	
	Return $class.Object
EndFunc


#class method GameLoop
Func _Magna_class__GameLoop($oSelf)
	
EndFunc


#class destructor
Func _Magna_class__Destructor1($oSelf)
	
EndFunc