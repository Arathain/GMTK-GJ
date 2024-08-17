extends Node2D

@onready
var enemyInstance = preload("res://scenes/gameplay/enemy_cell.tscn");

var cd := 0;


func _ready():
	var cell = enemyInstance.instantiate();
	cell.name = "Enemy1"
	var rot = randf()*TAU;
	cell.global_position = $Player.global_position +  Vector2(sin(rot), cos(rot))*500
	add_child(cell);
	pass

func _process(delta):
	var viewport = get_viewport()
	var viewport_size := viewport.get_visible_rect().size
	$CanvasLayer/TextureRect.material.set_shader_parameter("offset", Vector2($Player.position.x, $Player.position.y));
	$CanvasLayer/TextureRect.material.set_shader_parameter("scale", $Player/Camera2D.zoom*Vector2(1.0, viewport_size.x/viewport_size.y));
