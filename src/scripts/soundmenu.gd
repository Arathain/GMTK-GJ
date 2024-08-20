extends Control

class_name SoundMenu;

@export
var settingsmenu : SettingsMenu;



func _on_back_pressed():
	hide();
	settingsmenu.show();
