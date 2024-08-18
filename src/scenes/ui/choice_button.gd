extends Button

@onready
var topLabel = $MarginContainer2/Label;
@onready
var nameLabel = $MarginContainer/VBoxContainer/Label;

@onready
var oldLabel = $MarginContainer/VBoxContainer/HBoxContainer/LabelOld;
@onready
var newLabel = $MarginContainer/VBoxContainer/HBoxContainer/LabelNew;
@onready
var iconSprite = $CenterContainer/Control/Sprite2D;

@export
var selected : float = 0.0;

var upgradeType : PlayerStorage.UpgradeType = PlayerStorage.UpgradeType.HP;

func updateInfo(type : PlayerStorage.UpgradeType):
	topLabel.text = "Lv." + str(PlayerStorage.levels[type]+1);
	nameLabel.text = PlayerStorage.nameLookup[type];
	iconSprite.texture = PlayerStorage.texLookup[type];
	upgradeType = type;
	oldLabel.text = str(PlayerStorage.getValue(upgradeType)) + "" if (upgradeType == PlayerStorage.UpgradeType.HP || PlayerStorage.UpgradeType.HP_REGEN || PlayerStorage.UpgradeType.DEF || PlayerStorage.UpgradeType.DROP) else "%"
	newLabel.text = str(PlayerStorage.getValueOffs(upgradeType, 1)) + "" if (upgradeType == PlayerStorage.UpgradeType.HP || PlayerStorage.UpgradeType.HP_REGEN || PlayerStorage.UpgradeType.DEF || PlayerStorage.UpgradeType.DROP) else "%"

func _physics_process(delta):
	var prev = selected;
	if(is_hovered()):
		selected += 0.02;
	else:
		selected -= 0.02;
	selected = clamp(selected, 0.0, 1.0);
	
	material.set_shader_parameter("selected", selected);
