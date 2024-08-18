extends Node

var level := 1;
var nextLevel := 5;
var components : Array[int] = [0, 0, 0]

var levels := {}

enum UpgradeType {
	HP,
	HP_REGEN,
	DEF,
	ATK,
	SPD,
	DROP,
	ABSPD
}

@onready
var texLookup := {
	PlayerStorage.UpgradeType.HP : preload("res://assets/texture/ui/hp.png"),
	PlayerStorage.UpgradeType.HP_REGEN : preload("res://assets/texture/ui/hp_regen.png"),
	PlayerStorage.UpgradeType.DEF : preload("res://assets/texture/ui/def.png"),
	PlayerStorage.UpgradeType.ATK : preload("res://assets/texture/ui/atk.png"),
	PlayerStorage.UpgradeType.SPD : preload("res://assets/texture/ui/spd.png"),
	PlayerStorage.UpgradeType.DROP : preload("res://assets/texture/ui/drop.png"),
	PlayerStorage.UpgradeType.ABSPD : preload("res://assets/texture/ui/abspd.png")
}

@onready
var nameLookup := {
	PlayerStorage.UpgradeType.HP : "Max. HP",
	PlayerStorage.UpgradeType.HP_REGEN : "HP Regen.",
	PlayerStorage.UpgradeType.DEF : "Defense",
	PlayerStorage.UpgradeType.ATK : "Damage",
	PlayerStorage.UpgradeType.SPD : "Mov. Speed",
	PlayerStorage.UpgradeType.DROP : "Max Drops",
	PlayerStorage.UpgradeType.ABSPD : "Ability Spd."
}

@onready
var diffLookup := {
	PlayerStorage.UpgradeType.HP : 5,
	PlayerStorage.UpgradeType.HP_REGEN : 2,
	PlayerStorage.UpgradeType.DEF : 4,
	PlayerStorage.UpgradeType.ATK : 5,
	PlayerStorage.UpgradeType.SPD : 9,
	PlayerStorage.UpgradeType.DROP : 1,
	PlayerStorage.UpgradeType.ABSPD : 9
}

@onready
var baseLookup := {
	PlayerStorage.UpgradeType.HP : 20,
	PlayerStorage.UpgradeType.HP_REGEN : 0,
	PlayerStorage.UpgradeType.DEF : 0,
	PlayerStorage.UpgradeType.ATK : 100,
	PlayerStorage.UpgradeType.SPD : 100,
	PlayerStorage.UpgradeType.DROP : 2,
	PlayerStorage.UpgradeType.ABSPD : 100
}

func getValue(type : PlayerStorage.UpgradeType):
	return baseLookup[type] + levels[type]*diffLookup[type];

func getValueOffs(type : PlayerStorage.UpgradeType, offs : int):
	return baseLookup[type] + (levels[type]+offs)*diffLookup[type];

func getDecimal(type : PlayerStorage.UpgradeType):
	return (baseLookup[type] + levels[type]*diffLookup[type])*0.01;

func levelIncrement(type : UpgradeType):
	levels[type] += 1;
	SignalBus.cellUpgrade.emit(type);
	
func levelDecrement(type : UpgradeType):
	levels[type] = max(levels[type]-1, 0);

func _ready():
	for key in UpgradeType.values():
		levels[key] = 0;

func addComponent(type : GlobalStorage.CellType):
	components[type] += 1;
	if(components[0] + components[1] + components[2] >= nextLevel):
		levelUp(getHighest());
		components = [0, 0, 0];

func reset():
	level = 1;
	nextLevel = 5;
	levels = {};
	components = [0, 0, 0];

func levelUp(type : GlobalStorage.CellType):
	level += 1;
	nextLevel += 3;
	SignalBus.levelUp.emit(type);

func getHighest():
	if(components[0] > components[2]):
		if(components[1] > components[0]):
			return 1;
		else:
			return 0;
	else:
		if(components[1] > components[2]):
			return 1;
		else:
			return 2;
