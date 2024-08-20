extends Node

var level := 1;
var highestLevel := 1;
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
	ABSPD,
	GRAB,
	EXPLODE,
	ORBIT,
	SHOTGUN
}

@onready
var playerPos := Vector2.ZERO;

@onready
var texLookup := {
	PlayerStorage.UpgradeType.HP : preload("res://assets/texture/ui/hp.png"),
	PlayerStorage.UpgradeType.HP_REGEN : preload("res://assets/texture/ui/hp_regen.png"),
	PlayerStorage.UpgradeType.DEF : preload("res://assets/texture/ui/def.png"),
	PlayerStorage.UpgradeType.ATK : preload("res://assets/texture/ui/atk.png"),
	PlayerStorage.UpgradeType.SPD : preload("res://assets/texture/ui/spd.png"),
	PlayerStorage.UpgradeType.DROP : preload("res://assets/texture/ui/drop.png"),
	PlayerStorage.UpgradeType.ABSPD : preload("res://assets/texture/ui/abspd.png"),
	PlayerStorage.UpgradeType.GRAB : preload("res://assets/texture/ui/grab.png"),
	PlayerStorage.UpgradeType.EXPLODE : preload("res://assets/texture/ui/explode.png"),
	PlayerStorage.UpgradeType.ORBIT : preload("res://assets/texture/ui/orbit.png"),
	PlayerStorage.UpgradeType.SHOTGUN : preload("res://assets/texture/ui/shotgun.png")
}

@onready
var eyeLookup := {
	PlayerStorage.UpgradeType.HP : preload("res://assets/texture/game/eye_hp.png"),
	PlayerStorage.UpgradeType.HP_REGEN : preload("res://assets/texture/game/eye_hp_regen.png"),
	PlayerStorage.UpgradeType.DEF : preload("res://assets/texture/game/eye_def.png"),
	PlayerStorage.UpgradeType.ATK : preload("res://assets/texture/game/eye_atk.png"),
	PlayerStorage.UpgradeType.SPD : preload("res://assets/texture/game/eye_spd.png"),
	PlayerStorage.UpgradeType.DROP : preload("res://assets/texture/game/eye_drop.png"),
	PlayerStorage.UpgradeType.ABSPD : preload("res://assets/texture/game/eye_abspd.png"),
	PlayerStorage.UpgradeType.GRAB : preload("res://assets/texture/game/eye_grab.png"),
	PlayerStorage.UpgradeType.EXPLODE : preload("res://assets/texture/game/eye_explode.png"),
	PlayerStorage.UpgradeType.ORBIT : preload("res://assets/texture/game/eye_orbit.png"),
	PlayerStorage.UpgradeType.SHOTGUN : preload("res://assets/texture/game/eye_shotgun.png")
}

@onready
var nameLookup := {
	PlayerStorage.UpgradeType.HP : "Max. HP",
	PlayerStorage.UpgradeType.HP_REGEN : "HP Regen.",
	PlayerStorage.UpgradeType.DEF : "Defense",
	PlayerStorage.UpgradeType.ATK : "Damage",
	PlayerStorage.UpgradeType.SPD : "Mov. Speed",
	PlayerStorage.UpgradeType.DROP : "Max Drops",
	PlayerStorage.UpgradeType.ABSPD : "Ability Spd.",
	PlayerStorage.UpgradeType.GRAB : "Grab Radius",
	PlayerStorage.UpgradeType.EXPLODE : "Explode Skill",
	PlayerStorage.UpgradeType.ORBIT : "Orbit Skill",
	PlayerStorage.UpgradeType.SHOTGUN : "Shotgun Skill"
}

@onready
var diffLookup := {
	PlayerStorage.UpgradeType.HP : 5,
	PlayerStorage.UpgradeType.HP_REGEN : 2,
	PlayerStorage.UpgradeType.DEF : 4,
	PlayerStorage.UpgradeType.ATK : 5,
	PlayerStorage.UpgradeType.SPD : 9,
	PlayerStorage.UpgradeType.DROP : 1,
	PlayerStorage.UpgradeType.ABSPD : 9,
	PlayerStorage.UpgradeType.GRAB : 10,
	PlayerStorage.UpgradeType.EXPLODE : 20,
	PlayerStorage.UpgradeType.ORBIT : 1,
	PlayerStorage.UpgradeType.SHOTGUN : 5
}

@onready
var baseLookup := {
	PlayerStorage.UpgradeType.HP : 15,
	PlayerStorage.UpgradeType.HP_REGEN : 0,
	PlayerStorage.UpgradeType.DEF : 0,
	PlayerStorage.UpgradeType.ATK : 100,
	PlayerStorage.UpgradeType.SPD : 100,
	PlayerStorage.UpgradeType.DROP : 2,
	PlayerStorage.UpgradeType.ABSPD : 100,
	PlayerStorage.UpgradeType.GRAB : 70,
	PlayerStorage.UpgradeType.EXPLODE : 90,
	PlayerStorage.UpgradeType.ORBIT : 0,
	PlayerStorage.UpgradeType.SHOTGUN : 0
}

@onready
var verifLookup := {}

func getValue(type : PlayerStorage.UpgradeType):
	return baseLookup[type] + levels[type]*diffLookup[type];

func getValueOffs(type : PlayerStorage.UpgradeType, offs : int):
	return baseLookup[type] + (levels[type]+offs)*diffLookup[type];

func getDecimal(type : PlayerStorage.UpgradeType):
	return (baseLookup[type] + levels[type]*diffLookup[type])*0.01;

func levelIncrement(type : UpgradeType):
	levels[type] += 1;
	level += 1;
	checkLevel();
	SignalBus.cellUpgrade.emit(type);
	
func levelDecrement(type : UpgradeType):
	levels[type] = max(levels[type]-1, 0);
	level -= 1;
	checkLevel();
	SignalBus.cellDowngrade.emit(type);

func checkLevel():
	if(level > highestLevel):
		highestLevel = level;

func _ready():
	for key in UpgradeType.values():
		levels[key] = 0;
	verifLookup[PlayerStorage.UpgradeType.HP] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.HP_REGEN] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.DEF] = GlobalStorage.CellType.SUSTAIN;
	verifLookup[PlayerStorage.UpgradeType.ATK] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.SPD] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.DROP] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.ABSPD] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.GRAB] = GlobalStorage.CellType.ATTACK;
	verifLookup[PlayerStorage.UpgradeType.EXPLODE] = GlobalStorage.CellType.SPECIAL;
	verifLookup[PlayerStorage.UpgradeType.ORBIT] = GlobalStorage.CellType.SPECIAL;
	verifLookup[PlayerStorage.UpgradeType.SHOTGUN] = GlobalStorage.CellType.SPECIAL;

func addComponent(type : GlobalStorage.CellType):
	components[type] += 1;
	if(components[0] + components[1] + components[2] >= nextLevel):
		levelUp(getHighest());
		components = [0, 0, 0];

func reset():
	highestLevel = 1;
	level = 1;
	nextLevel = 5;
	for key in UpgradeType.values():
		levels[key] = 0;
	components = [0, 0, 0];
	playerPos = Vector2.ZERO;

func levelUp(type : GlobalStorage.CellType):
	level += 1;
	checkLevel();
	SignalBus.levelUp.emit(type, components, nextLevel);
	nextLevel += 3;

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
