extends "res://scripts/settings.gd"

func _on_back_pressed():
	GlobalStorage.loadSceneTrans("gameplay/main", true);
