extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i = 0.0;
	var c = float(get_child_count());
	for child in get_children():
		var vec = (position-child.position);
		child.apply_central_force(vec*110.0);
		child.linear_damp = 5.0 + 15.0/vec.length()
