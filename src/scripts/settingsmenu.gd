extends Control

class_name SettingsMenu;

@export
var pausemenu : PauseMenu;
@export
var soundmenu : SoundMenu;
@export
var keymenu : KeyMenu;

@onready var main = $"../../"

func _on_back_pressed():
	hide();
	pausemenu.show();


func _on_key_config_pressed():
	hide();
	keymenu.show();


func _on_sound_pressed():
	hide();
	soundmenu.show();
