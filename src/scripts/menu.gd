extends Control

func _on_play_pressed():
	GlobalStorage.loadSceneTrans("gameplay/main", true);


func _on_settings_pressed():
	GlobalStorage.loadSceneTransition("settings");


func _on_quit_pressed():
	get_tree().quit(); # Replace with function body.
