extends CharacterBody2D

@onready
var player = get_node("/root/Node2D/Player")
@onready
var repo = get_node("/root/Node2D/ComponentRepo")

var cell_component = preload("res://scenes/gameplay/cell_component.tscn")

@export
var health = 30.0;

@export
var max_health := 30.0;

func _physics_process(delta):
	var dir = (player.global_position-global_position).normalized();
	velocity = dir * 35.0;
	move_and_slide();

func drop_components():
	for i in range(0, randi_range(1, 2)):
		var r = randf();
		var c = cell_component.instantiate()
		c.type = randi_range(0, 2)
		var pos = Vector2(sin(r*TAU), cos(r*TAU))*(1.0+randf()*60.0);
		c.updateTextures();
		c.global_position = global_position + pos;
		repo.call_deferred("add_child", c);

func enemy_take_damage(damage : float):
	health -= damage;
	if(health <= 0):
		drop_components();
		queue_free();
