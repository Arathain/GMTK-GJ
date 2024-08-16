extends Node2D

@onready
var cellInstance = preload("res://scenes/gameplay/cell.tscn");

@onready
var cells = $Cells;

var cd := 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	var cell = cellInstance.instantiate();
	cell.name = "Cell1"
	cells.add_child(cell);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	cd += 1;
	var input = Vector2(int(Input.is_action_pressed("m_right")) - int(Input.is_action_pressed("m_left")), int(Input.is_action_pressed("m_down")) - int(Input.is_action_pressed("m_up")))
	position += input;
	if(cd >= 200) :
		var cell = cellInstance.instantiate();
		cell.name = "Cell" + str(cells.get_child_count()+1)
		cells.add_child(cell);
		cd = 0;
	
