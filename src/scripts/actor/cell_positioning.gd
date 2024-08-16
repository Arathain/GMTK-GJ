extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i = 0.0;
	var c = float(get_child_count());
	for child in get_children():
		i += 1;
		var vec = Vector2(sin(i/c * TAU), cos(i/c * TAU));
		child.position = vec*128;
