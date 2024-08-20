extends RigidBody2D

class_name Cell

@export
var health = 20;

@export
var max_health := 20;

# TODO replace this with enemy-side sys
var hurt_cd:= 0.0;

var heal_cd := 0;

var age := 0;

@export var type : PlayerStorage.UpgradeType = 0;
var typeName := "hp";

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _animated_sprite_face = $AnimatedSprite2DFace
@onready var _eye_sprite = $Sprite2D

@onready
var typeTextures : Array[CompressedTexture2D];

func _ready():
	# typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	updateTypeName();
	SignalBus.cellUpgrade.connect(cellUpgrade)
	SignalBus.cellDowngrade.connect(cellUpgrade)
	_animated_sprite.play(getCellTypeStr() + "_idle")
	_eye_sprite.texture = PlayerStorage.eyeLookup[type];
	_animated_sprite_face.play("idle_" + typeName)

func getCellTypeStr():
	return GlobalStorage.cellTypeStr(PlayerStorage.verifLookup[type]);

func updateTypeName():
	typeName = str(PlayerStorage.UpgradeType.keys()[type]).to_lower();

func updateTextures():
	# typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	pass

func cellUpgrade(type : PlayerStorage.UpgradeType):
	if(type == PlayerStorage.UpgradeType.HP):
		var pmh = max_health;
		max_health = PlayerStorage.getValue(type);
		health = int(float(health)*float(max_health)/float(pmh));
	if(type == PlayerStorage.UpgradeType.GRAB):
		($CollectBox/CollisionShape2D.shape as CircleShape2D).radius = PlayerStorage.getValue(type);


func _process(delta):
	if(_animated_sprite.animation.contains("death")):
		_eye_sprite.hide();
	elif(!_eye_sprite.visible):
		_eye_sprite.show();
	var mult = sin(float(age)/180.0*TAU)*0.2+0.2;
	mult *= 1.0-health/max_health;
	var a = 1-hurt_cd*0.8;
	a *= (float(health)/float(max_health))*0.3+0.7;
	_animated_sprite.self_modulate.a = a;
	_animated_sprite.self_modulate.b = a-mult;
	_animated_sprite.self_modulate.g = a-mult;
	var vec = get_global_mouse_position()-global_position;
	vec *= 0.02;
	if(vec.length() > 4.0):
		vec = vec.normalized()*4.0;
	_eye_sprite.position = vec.rotated(-rotation);

func _physics_process(delta):
	var reg = PlayerStorage.getValue(PlayerStorage.UpgradeType.HP_REGEN);
	age += 1;
	if(reg > 0):
		heal_cd -= 1;
		if(heal_cd <= 0):
			heal_cd = 6000;
			health += reg;
			if(health > max_health):
				health = max_health;
	if hurt_cd > 0.0:
		hurt_cd = max(0.0, hurt_cd-1.0/80.0);
	var overlap = %HurtBox.get_overlapping_bodies();
	if (overlap.size() > 0.) && (hurt_cd == 0.0):
		health -= 5;
		hurt_cd = 1.0;
		if health <= 0:
			_animated_sprite.play(getCellTypeStr() + "_death");
			_animated_sprite_face.play("death_" + typeName);
		else:
			_animated_sprite.play(getCellTypeStr() + "_hurt")
			_animated_sprite_face.play("hurt_" + typeName);

func damage_cell(dmg : float):
	health -= dmg;
	hurt_cd = 1.0;
	if health <= 0:
		_animated_sprite.play(getCellTypeStr() + "_death");
		_animated_sprite_face.play("death_" + typeName);
	else:
		_animated_sprite.play(getCellTypeStr() + "_hurt")
		_animated_sprite_face.play("hurt_" + typeName);

func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation.contains("death"):
		SignalBus.cell_death.emit(self)
	else:
		_animated_sprite.play(getCellTypeStr() + "_idle");
		_animated_sprite_face.play("idle_" + typeName)

