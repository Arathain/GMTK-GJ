extends Node2D

@export
var player : Player;

var time := 0.0;

func _process(delta):
	var i = 0.0;
	var c = float(get_child_count());
	for child in get_children():
		var rot = i/c * TAU + time;
		child.rotation = -rot;
		child.position = Vector2(sin(rot), cos(rot))*(64.0+player.cached_offset);
		i += 1.0;

func _physics_process(delta):
	time += delta*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD);
