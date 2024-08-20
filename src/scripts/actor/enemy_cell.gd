extends CharacterBody2D

class_name EnemyCell;

@onready
var player = get_node("/root/Node2D/Player")
@onready
var repo = get_node("/root/Node2D/ComponentRepo")

var cell_component = preload("res://scenes/gameplay/cell_component.tscn")

@export
var health = 30.0;

@export
var max_health := 30.0;

var age := 0;

var str := 0.0;

var hurt_cd:= 0.0;

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	str = randf();
	_animated_sprite.play("idle")

func _process(delta):
	var mult = sin(float(age)/180.0*TAU)*0.3+0.3;
	mult *= 1.0-health/max_health;
	_animated_sprite.modulate.a = 1.0-hurt_cd*0.4;
	_animated_sprite.modulate.b = 1.0-hurt_cd*0.2-mult;
	_animated_sprite.modulate.g = 1.0-hurt_cd*0.2-mult;

func _physics_process(delta):
	if hurt_cd > 0.0:
		hurt_cd = max(0.0, hurt_cd-1.0/40.0);	
	if _animated_sprite.animation.contains("death"):
		return
	age += 1;
	var diff = (player.global_position-global_position);
	var dir = diff.normalized();
	if(diff.length() > 420.0 * 4 / player.camera.zoom.x && health == max_health && age > 120*30):
		queue_free();
	velocity = dir * 125.0 * (0.925+str*0.1);
	move_and_slide();
	look_at(player.global_position)
	rotation -= PI*0.5;
	global_position = GlobalStorage.clampPosBuffer(global_position, 45.0);

func drop_components():
	for i in range(0, randi_range(1, PlayerStorage.getValue(PlayerStorage.UpgradeType.DROP))):
		var r = randf();
		var c = cell_component.instantiate()
		var t = randi_range(0, 7);
		c.type = 0 if (t < 2) else 1 if (t < 6) else 2;
		var pos = Vector2(sin(r*TAU), cos(r*TAU))*(1.0+randf()*60.0);
		c.updateTextures();
		c.global_position = global_position + pos;
		repo.call_deferred("add_child", c);

func enemy_take_damage(damage : float):
	health -= damage;
	hurt_cd = 1.0;
	if health <= 0:
		_animated_sprite.play("death");
		$CollisionShape2D.set_deferred("disabled", true);
	else:
		_animated_sprite.play("hurt");

func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation.contains("death"):
		drop_components();
		queue_free();
	else:
		_animated_sprite.play("idle");
