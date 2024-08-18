extends RigidBody2D

class_name Cell

@export
var health = 20;

@export
var max_health := 20;

# TODO replace this with enemy-side sys
var hurt_cd:= 0.0;

var heal_cd := 0;

@export var type : PlayerStorage.UpgradeType = 0;

@onready var _animated_sprite = $AnimatedSprite2D

@onready
var typeTextures : Array[CompressedTexture2D];

func _ready():
	# typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	# updateTextures();
	SignalBus.cellUpgrade.connect(cellUpgrade)
	_animated_sprite.play("default")
	
func updateTextures():
	# typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	# $Sprite2D.texture = typeTextures[type];
	pass

func cellUpgrade(type : PlayerStorage.UpgradeType):
	if(type == PlayerStorage.UpgradeType.HP):
		var pmh = max_health;
		max_health = PlayerStorage.getValue(type);
		health = int(float(health)*float(max_health)/float(pmh));


func _process(delta):
	var a = 1-hurt_cd*0.8;
	a *= (health/max_health)*0.5+0.5;
	$AnimatedSprite2D.self_modulate.r = a;
	$AnimatedSprite2D.self_modulate.g = a;
	$AnimatedSprite2D.self_modulate.b = a;

func _physics_process(delta):
	var reg = PlayerStorage.getValue(PlayerStorage.UpgradeType.HP_REGEN);
	if(reg > 0):
		heal_cd -= 1;
		if(heal_cd <= 0):
			heal_cd = 6000;
			health += PlayerStorage.getValue(PlayerStorage.UpgradeType.HP_REGEN);
			if(health > max_health):
				health = max_health;
	if hurt_cd > 0.0:
		hurt_cd = max(0.0, hurt_cd-1.0/80.0);
	var overlap = %HurtBox.get_overlapping_bodies();
	if (overlap.size() > 0.) && (hurt_cd == 0.0):
		health -= 5;
		hurt_cd = 1.0;
		if health <= 0:
			SignalBus.cell_death.emit(self)
