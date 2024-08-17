extends Node2D

class_name Player

@onready
var cellInstance = preload("res://scenes/gameplay/cell.tscn");

@onready
var bulletInstance = preload("res://scenes/gameplay/basic_bullet.tscn")

@onready
var camera = $Camera2D;

@onready
var cells = $Cells;

var cd := 0;

var child_cache := 1;
var cached_offset := 70;

# Called when the node enters the scene tree for the first time.
func _ready():
	var cell = cellInstance.instantiate();
	cell.name = "Cell1"
	cells.add_child(cell);
	SignalBus.cell_death.connect(_cell_death)
	SignalBus.levelUp.connect(levelUp)
	pass # Replace with function body.ww

func _cell_death(cell : Cell):
	cell.queue_free();

func levelUp(type : GlobalStorage.CellType):
	var cell = cellInstance.instantiate();
	cell.name = "Cell" + str(cells.get_child_count()+1);
	cell.type = type;
	cell.updateTextures();
	var rot = randf()*TAU;
	cell.position = Vector2(sin(rot), cos(rot))*50;
	cells.call_deferred("add_child", cell);


func _process(delta):
	#if(cells.get_child_count() != child_cache) :
	child_cache = cells.get_child_count();
	var maxOffset := 30;
	for child in cells.get_children():
		var len = (global_position-child.global_position).length()+30;
		if(len > maxOffset):
			maxOffset = len;
	cached_offset = maxOffset+30;
	$Marker2D/Sprite2D.position.x = cached_offset;
	var vec = get_global_mouse_position();
	$Marker2D/Sprite2D.scale.y = (vec-global_position).length()/200.0;
	$Marker2D.look_at(vec);

func shoot():
	if($Marker2D/Timer.is_stopped()):
		var nb = bulletInstance.instantiate();
		nb.global_rotation = $Marker2D/Sprite2D.global_rotation + randf_range(0.0, 0.4)-0.2;
		nb.global_position = $Marker2D/Sprite2D.global_position;
		$boolets.add_child(nb)
		$Marker2D/Timer.start();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_action_pressed("basic_attack")):
		shoot();
	var input = Vector2(int(Input.is_action_pressed("m_right")) - int(Input.is_action_pressed("m_left")), int(Input.is_action_pressed("m_down")) - int(Input.is_action_pressed("m_up"))).normalized()
	position += input*2.;
	var zoom = 2.0/(log(cells.get_child_count()+1.0)/log(10.0)+1.0)
	camera.zoom = Vector2(zoom, zoom);
	
