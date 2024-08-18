extends Node2D

class_name CellComponent

@export var type : GlobalStorage.CellType = 0;

@onready
var typeTextures : Array[CompressedTexture2D];

var ticker := 0;

func _ready():
	updateTextures();
	
func updateTextures():
	typeTextures = [preload("res://assets/texture/game/green_hand_peace.png"), preload("res://assets/texture/game/blue_hand_peace.png"), preload("res://assets/texture/game/purple_hand_peace.png")]
	$Sprite2D.texture = typeTextures[type];
	

func _process(delta):
	ticker += 1;
	if(ticker == 240):
		ticker = 0;
	$Sprite2D.position.y = sin((ticker + delta)/(240.0) * TAU)


func _on_area_entered(area):
	if(area.is_in_group("component_collector")):
		PlayerStorage.addComponent(type);
		queue_free();
