extends Node2D

class_name CellComponent

@export var type : GlobalStorage.CellType = 0;

@onready
var typeTextures : Array[CompressedTexture2D];

var ticker := 0;

var delta := 0.0;

var area = null;

func _ready():
	updateTextures();
	
func updateTextures():
	typeTextures = [preload("res://assets/texture/game/cc_sustain.png"), preload("res://assets/texture/game/cc_attack.png"), preload("res://assets/texture/game/cc_special.png")]
	$Sprite2D.texture = typeTextures[type];
	

func _process(delta):
	ticker += 1;
	if(ticker == 240):
		ticker = 0;
	$Sprite2D.position.y = sin((ticker + delta)/(240.0) * TAU)*6.0

func _physics_process(delta):
	if(area != null):
		self.delta += 1.0/40.0;
		if(self.delta >= 1.0):
			PlayerStorage.addComponent(type);
			queue_free();
		global_position = lerp(global_position, area.global_position, self.delta);

func _on_area_entered(areaIn):
	if(areaIn.is_in_group("component_collector")):
		area = areaIn;
