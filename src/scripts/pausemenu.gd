extends Control

@onready var main = $"../../"

func _on_save__quit_pressed():
	get_tree().paused = false;
	GlobalStorage.loadSceneTransition("menu");

func _on_resume_pressed():
	main.pause();


func _on_settings_pressed():
	get_tree().paused = false;
	GlobalStorage.loadSceneTransition("settings");
