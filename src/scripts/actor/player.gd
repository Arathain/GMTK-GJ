extends Node2D

class_name Player

@onready
var cellInstance = preload("res://scenes/gameplay/cell.tscn");

@onready
var bulletInstance = preload("res://scenes/gameplay/basic_bullet.tscn")

@onready
var expInstance = preload("res://scenes/gameplay/explosive_player.tscn")

@onready
var orbitInstance = preload("res://scenes/gameplay/orbit_bullet.tscn")

@onready
var camera = $Camera2D;

@onready
var cells = $Cells;

@onready
var orbit = $Orbit;

@onready
var shotgunarea := $Marker2D/Marker2D/Area2D;
@onready
var shotgunparticle := $Marker2D/Marker2D/GPUParticles2D;

var cd := 0;

var child_cache := 1;
var cached_offset := 70;
var velocity := Vector2(0,0);

# Called when the node enters the scene tree for the first time.
func _ready():
	position = PlayerStorage.playerPos;
	if(PlayerStorage.level == 1):
		var cell = cellInstance.instantiate();
		cell.name = "Cell1"
		cell.type = PlayerStorage.UpgradeType.HP;
		cells.add_child(cell);
		PlayerStorage.levels[PlayerStorage.UpgradeType.HP] += 1;
	else:
		var cap := PlayerStorage.level;
		var iter := 0;
		for i in PlayerStorage.UpgradeType.values():
			var typeCap = PlayerStorage.levels[i];
			if(iter >= typeCap):
				continue
			else:
				iter += 1;
				cellUpgrade(i);
	SignalBus.cell_death.connect(_cell_death)
	SignalBus.cellUpgrade.connect(cellUpgrade)
	pass # Replace with function body.ww

func _cell_death(cell : Cell):
	PlayerStorage.levelDecrement(cell.type);
	PlayerStorage.nextLevel -= 4;
	cell.queue_free();
	rebuildOrbit();

func cellUpgrade(type : PlayerStorage.UpgradeType):
	var cell = cellInstance.instantiate();
	cell.name = "Cell" + str(cells.get_child_count()+1);
	cell.type = type;
	cell.updateTextures();
	var rot = randf()*TAU;
	cell.position = Vector2(sin(rot), cos(rot))*50;
	cells.call_deferred("add_child", cell);
	rebuildOrbit();
	$Marker2D/Timer.wait_time = 0.3 / PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD)
	$Marker2D/ExpTimer.wait_time = 12.0 / PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD)
	$Marker2D/ShotgunTimer.wait_time = 2.0 / PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD)

func rebuildOrbit():
	var orbitBullets = PlayerStorage.getValue(PlayerStorage.UpgradeType.ORBIT);
	if(orbit.get_child_count() != orbitBullets):
		$AudioStreamPlayer2D.play();
		for child in orbit.get_children():
			child.queue_free();
		for i in range(0, orbitBullets):
			var rot = float(i)/float(orbitBullets) * TAU;
			var nb = orbitInstance.instantiate();
			nb.rotation = -rot;
			nb.position = Vector2(sin(rot), cos(rot))*(29.0+cached_offset);
			orbit.add_child(nb)


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
	$Marker2D/Marker2D.position.x = cached_offset;
	var vec = get_global_mouse_position();
	$Marker2D/Sprite2D.scale.y = (vec-global_position).length()/200.0 * 0.0625;
	$Marker2D.look_at(vec);
	if(orbit.get_child_count() > 0 && !$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play();

func shoot():
	if($Marker2D/Timer.is_stopped()):
		$ShootPlayer.play();
		var nb = bulletInstance.instantiate();
		nb.global_rotation = $Marker2D/Sprite2D.global_rotation + randf_range(0.0, 0.2)-0.1;
		nb.global_position = $Marker2D/Sprite2D.global_position+(global_position-$Marker2D/Sprite2D.global_position)*0.3;
		$boolets.add_child(nb)
		$Marker2D/Timer.start();

func shoot_explosive():
	if($Marker2D/ExpTimer.is_stopped()):
		var nb = expInstance.instantiate();
		nb.global_rotation = $Marker2D/Sprite2D.global_rotation;
		nb.global_position = $Marker2D/Sprite2D.global_position+(global_position-$Marker2D/Sprite2D.global_position)*0.3;
		$boolets.add_child(nb)
		$Marker2D/ExpTimer.start();
		var randomChild := randi_range(0, cells.get_child_count()-1)
		cells.get_child(randomChild).queue_free();
		PlayerStorage.nextLevel -= 4;

func shotgun():
	if($Marker2D/ShotgunTimer.is_stopped()):
		$Marker2D/ShotgunPlayer.play();
		for body in shotgunarea.get_overlapping_bodies():
			if(body.has_method("enemy_take_damage")):
				body.enemy_take_damage(PlayerStorage.getValue(PlayerStorage.UpgradeType.SHOTGUN)*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ATK));
		shotgunparticle.emitting = true;
		$Marker2D/ShotgunTimer.start();
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	PlayerStorage.playerPos = position;
	if(cells.get_child_count() == 0):
		pass
	else:
		if(Input.is_action_pressed("basic_attack")):
			shoot();
		if(Input.is_action_pressed("skill_1") && PlayerStorage.levels[PlayerStorage.UpgradeType.EXPLODE] > 0) && cells.get_child_count() > 1:
			shoot_explosive();
		if(Input.is_action_pressed("skill_2") && PlayerStorage.levels[PlayerStorage.UpgradeType.SHOTGUN] > 0):
			shotgun();
		var input = Vector2(int(Input.is_action_pressed("m_right")) - int(Input.is_action_pressed("m_left")), int(Input.is_action_pressed("m_down")) - int(Input.is_action_pressed("m_up"))).normalized()
		var spd = 1.5*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.SPD);
		velocity = (velocity*0.99 + input*spd);
		if(velocity.length() > spd*1.7):
			velocity = velocity.normalized()*(spd*1.7);
		position += velocity;
		position = GlobalStorage.clampPosBuffer(position, cached_offset * 0.25);
		var zoom = 2.0/(log(cells.get_child_count()+1.0)/log(10.0)+1.0)
		camera.zoom = Vector2(zoom, zoom);
	


func _on_audio_stream_player_2d_finished():
	if(orbit.get_child_count() > 0):
		$AudioStreamPlayer2D.play();
