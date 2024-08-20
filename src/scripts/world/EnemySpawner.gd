extends Node2D

var wave_cd := 0;
var next_delay := 120*10;
var enemy = preload("res://scenes/gameplay/enemy_cell.tscn");
var enemyexp = preload("res://scenes/gameplay/enemy_explosive.tscn");

func spawn_wave():
	var r = randf();
	var megaWave = randi_range(0, 6) == 1;
	if(megaWave):
		var amount = randi_range(5, 7+PlayerStorage.level/3);
		var dir = Vector2(sin(r*TAU), cos(r*TAU)) if $"../Player".velocity.length() < 0.02 else $"../Player".velocity.normalized();
		dir = dir.rotated(-float(amount)*0.5*(1.0/20.0)*PI)
		for i in range(0, amount):
			var explosive = randi_range(0, 20-mini(PlayerStorage.level/4, 14)) == 1;
			var e = enemyexp.instantiate() if explosive else enemy.instantiate();
			var ra = randf();
			e.global_position = $"../Player".global_position + dir.rotated(i*(1.0/15.0)*PI) * 420.0 * 4 / $"../Player/Camera2D".zoom.x + Vector2(sin(ra*TAU), cos(ra*TAU)) * 20.0 * (randf()+1.0);
			e.global_position = GlobalStorage.clampPosBuffer(e.global_position, 60.0);
			add_child(e);
	else:
		var pos = $"../Player".global_position + Vector2(sin(r*TAU), cos(r*TAU)) * 420.0 * 4 / $"../Player/Camera2D".zoom.x;
		for i in range(0, randi_range(2, 4)):
			var explosive = randi_range(0, 20-mini(PlayerStorage.level/4, 14)) == 1;
			var e = enemyexp.instantiate() if explosive else enemy.instantiate();
			if(i == 0):
				e.global_position = pos;
			else:
				var ra = randf();
				e.global_position = pos + Vector2(sin(ra*TAU), cos(ra*TAU))*3.0*20.0;
			e.global_position = GlobalStorage.clampPosBuffer(e.global_position, 60.0);
			add_child(e);

func _ready():
	spawn_wave();

func _physics_process(delta):
	wave_cd += 1;
	
	if(wave_cd >= next_delay):
		spawn_wave();
		next_delay = 120*(7-mini(PlayerStorage.level/5, 7)) + 120*randi_range(0, 2);
		wave_cd = 0;
