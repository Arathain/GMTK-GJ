extends Control

class_name UpgradeMenu

@onready
var verifLookup := {}

@onready
var b1 := $MarginContainer/HBoxContainer/ChoiceButton1;
@onready
var b2 := $MarginContainer/HBoxContainer/ChoiceButton2;
@onready
var b3 := $MarginContainer/HBoxContainer/ChoiceButton3;

func _ready():
	verifLookup[PlayerStorage.UpgradeType.HP] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.HP_REGEN] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.DEF] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.ATK] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.SPD] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.DROP] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.ABSPD] = GlobalStorage.CellType.ATTACK;
	pass

func chooseUpgrades(type : GlobalStorage.CellType):
	var option1 := randi_range(0, PlayerStorage.UpgradeType.size()-1)
	var option2 := 0;
	var option3 := randi_range(0, PlayerStorage.UpgradeType.size()-2)
	if(option3 >= option1):
		option3 += 1;
	if(verifLookup[option1] != type && verifLookup[option2] != type):
		match type:
			GlobalStorage.CellType.SUSTAIN:
				option2 = randi_range(0, 2);
			GlobalStorage.CellType.ATTACK:
				option2 = randi_range(0, 3)+3;
			_:
				option2 = randi_range(0, PlayerStorage.UpgradeType.size()-3);
				if(option2 >= option1):
					option2 += 1;
				if(option2 >= option3):
					option2 += 1;
	else:
		if(option2 >= option1):
			option2 += 1;
		if(option2 >= option3):
			option2 += 1;
	b1.updateInfo(option1 as PlayerStorage.UpgradeType);
	b2.updateInfo(option2 as PlayerStorage.UpgradeType);
	b3.updateInfo(option3 as PlayerStorage.UpgradeType);


func _on_choice_button_1_pressed():
	PlayerStorage.levelIncrement(b1.upgradeType);
	get_tree().paused = false;
	hide();


func _on_choice_button_2_pressed():
	PlayerStorage.levelIncrement(b2.upgradeType);
	get_tree().paused = false;
	hide();


func _on_choice_button_3_pressed():
	PlayerStorage.levelIncrement(b3.upgradeType);
	get_tree().paused = false;
	hide();
