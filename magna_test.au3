;magna_test.au3

Global $m = _Magna_Init("Some Title", 320, 240, _SetupFunc, _UpdateFunc, _RenderFunc)

Func SceneLoad()
	; some actions here
	$m.AssetManager.Load("bgm/village.mp3")
	local $entity = $m.EntityManager.New("hero")
	$m.EntityManager.Get("hero")
	$m.EntityManager.Find("component:position,velocity")
EndFunc
$m.SceneManager.AddScene(SceneLoad)


$m.GameLoop.Start()
$m.GameLoop.Pause()
$m.GameLoop.Resume()
$m.GameLoop.Stop()

; .isPaused is readonly
If $m.GameLoop.isPaused Then
	
EndIf