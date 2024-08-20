extends Control

class_name UpgradeMenu

@onready
var enter_cd := 0;

@onready
var b1 := $MarginContainer/HBoxContainer/ChoiceButton1;
@onready
var b2 := $MarginContainer/HBoxContainer/ChoiceButton2;
@onready
var b3 := $MarginContainer/HBoxContainer/ChoiceButton3;

func _ready():
	pass

func getUpgradeType(type : GlobalStorage.CellType):
	var option := 0;
	match type:
			GlobalStorage.CellType.SUSTAIN:
				option = randi_range(0, 2);
			GlobalStorage.CellType.ATTACK:
				option = randi_range(0, 4)+3;
			_:
				option = randi_range(0, 2)+8;
	return option;

func chooseType(array : Array[int], nextLevel : int):
	var randint := randi_range(1, nextLevel);
	if(randint <= array[0]):
		return GlobalStorage.CellType.SUSTAIN;
	elif(randint <= array[1]+array[0]):
		return GlobalStorage.CellType.ATTACK;
	else:
		return GlobalStorage.CellType.SPECIAL;

func chooseUpgrades(type : GlobalStorage.CellType, array : Array[int], nextLevel : int):
	$AudioStreamPlayer2D.play();
	enter_cd = 80;
	var type1 := chooseType(array, nextLevel) as GlobalStorage.CellType;
	var type2 := chooseType(array, nextLevel) as GlobalStorage.CellType;
	var option1 := getUpgradeType(type1) as int;
	var option2 := 0;
	var option3 := getUpgradeType(type2) as int;
	if(option1 == option3):
		if(option1 == 2 || option1 == 7 || option1 == 10):
			option3 -= 1;
		else:
			option3 += 1;
	
	if(type1 != type && type2 != type):
		option2 = getUpgradeType(type);
	else:
		option2 = getUpgradeType(chooseType(array, nextLevel)) as int;
		if(option2 == option1):
			if(option1 == 2 || option1 == 7 || option1 == 10):
				option2 -= 1;
			else:
				option2 += 1;
		if(option2 == option3):
			if(option3 == 2 || option3 == 7 || option3 == 10):
				option2 -= 1;
			else:
				option2 += 1;
	
	b1.updateInfo(option1 as PlayerStorage.UpgradeType);
	b2.updateInfo(option2 as PlayerStorage.UpgradeType);
	b3.updateInfo(option3 as PlayerStorage.UpgradeType);

func _process(delta):
	if(enter_cd > 0):
		var scal = (80.0-enter_cd)/80.0;
		scal *= scal;
		b1.modulate.a = scal;
		b2.modulate.a = scal;
		b3.modulate.a = scal;
	else:
		b1.modulate.a = 1.0;
		b2.modulate.a = 1.0;
		b3.modulate.a = 1.0;

func _physics_process(delta):
	if(enter_cd > 0):
		b1.disabled = true;
		b2.disabled = true;
		b3.disabled = true;
		enter_cd -= 1;
	else:
		b1.disabled = false;
		b2.disabled = false;
		b3.disabled = false;

func _on_choice_button_1_pressed():
	if(enter_cd == 0):
		PlayerStorage.levelIncrement(b1.upgradeType);
		get_tree().paused = false;
		hide();


func _on_choice_button_2_pressed():
	if(enter_cd == 0):
		PlayerStorage.levelIncrement(b2.upgradeType);
		get_tree().paused = false;
		hide();


func _on_choice_button_3_pressed():
	if(enter_cd == 0):
		PlayerStorage.levelIncrement(b3.upgradeType);
		get_tree().paused = false;
		hide();
