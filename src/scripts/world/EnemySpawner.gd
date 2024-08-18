extends Node2D

var wave_cd := 0;
var next_delay := 120*10;
var enemy = preload("res://scenes/gameplay/enemy_cell.tscn");


func _physics_process(delta):
	wave_cd += 1;
	
	if(wave_cd >= next_delay):
		var r = randf();
		var pos = $"../Player".global_position + Vector2(sin(r*TAU), cos(r*TAU)) * 420.0 * 4 / $"../Player/Camera2D".zoom.x;
		for i in range(0, randi_range(2, 6)):
			var e = enemy.instantiate();
			if(i == 0):
				e.global_position = pos;
			else:
				var ra = randf();
				e.global_position = pos + Vector2(sin(ra*TAU), cos(ra*TAU))*3.0*20.0;
			add_child(e);
		next_delay = 120*(8-mini(PlayerStorage.level/2, 8)) + 120*randi_range(0, 2);
		wave_cd = 0;
