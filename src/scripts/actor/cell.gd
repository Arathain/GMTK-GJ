extends RigidBody2D

class_name Cell

@export
var health = 20;

@export
var max_health := 20;

# TODO replace this with enemy-side sys
var hurt_cd:= 0.0;

@export var type : GlobalStorage.CellType = 0;

@onready
var typeTextures : Array[CompressedTexture2D];

func _ready():
	typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	updateTextures();
	
func updateTextures():
	typeTextures = [preload("res://assets/texture/game/green_body_circle.png"), preload("res://assets/texture/game/blue_body_circle.png"), preload("res://assets/texture/game/purple_body_circle.png")];
	$Sprite2D.texture = typeTextures[type];

func _process(delta):
	var a = 1-hurt_cd*0.8;
	a *= (health/max_health)*0.5+0.5;
	$Sprite2D.self_modulate.r = a;
	$Sprite2D.self_modulate.g = a;
	$Sprite2D.self_modulate.b = a;

func _physics_process(delta):
	if hurt_cd > 0.0:
		hurt_cd = max(0.0, hurt_cd-1.0/80.0);
	var overlap = %HurtBox.get_overlapping_bodies();
	if (overlap.size() > 0.) && (hurt_cd == 0.0):
		health -= 5;
		hurt_cd = 1.0;
		if health <= 0:
			SignalBus.cell_death.emit(self)
