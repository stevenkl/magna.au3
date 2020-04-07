;magna_test.au3

Global $m = _Magna_Init("Some Title", 320, 240, _SetupFunc, _UpdateFunc, _RenderFunc)

Func SceneLoad()
	; some actions here
	$m.AssetManager.Load("bgm/village.mp3")
	local $entity = $m.Entity.New()
	$entity.Name = "Hero"
EndFunc
$m.SceneManager.AddScene(SceneLoad)