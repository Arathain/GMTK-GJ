extends Node2D

@onready
var enemyInstance = preload("res://scenes/gameplay/enemy_cell.tscn");

@onready
var pauseMenu = $PauseScreen/Control
@onready
var upgradeMenu : UpgradeMenu = $UpgradeScreen/Control
var paused = false;

@onready
var gameover := $PauseScreen/Control5;

var cd := 0;

@onready
var timeLabel := $HUD/Control/MarginContainer/Label;

@onready
var physicsFrames := 0.0;

func _ready():
	SignalBus.levelUp.connect(levelUp);
	
func levelUp(type : GlobalStorage.CellType, array : Array[int], nextLevel : int):
	upgradeMenu.show();
	get_tree().paused = true;
	upgradeMenu.chooseUpgrades(type, array, nextLevel);

func pause():
	if paused:
		pauseMenu.hide();
		get_tree().paused = false;
	else:
		pauseMenu.show();
		get_tree().paused = true;
	paused = !paused;

func _physics_process(delta):
	if($Player.cells.get_child_count() == 0):
		gameover.show();
		gameover.initScore(PlayerStorage.highestLevel*30+int(physicsFrames)*3+PlayerStorage.components[0]+PlayerStorage.components[1]+PlayerStorage.components[2]);
		get_tree().paused = true;
		PlayerStorage.reset();
	if(!get_tree().paused):
		physicsFrames += delta;

func _process(delta):
	if(Input.is_action_just_pressed("pause")):
		pause();
	var viewport = get_viewport()
	var secs = floor(physicsFrames);
	var min = int(floor(secs/60.0));
	timeLabel.text = str(min) + "m" + str(int(secs)-min*60) + "s" if min > 0 else str(int(secs)) + "s";
	var viewport_size := viewport.get_visible_rect().size
	$CanvasLayer/TextureRect.material.set_shader_parameter("offset", Vector2($Player.position.x, $Player.position.y));
	$CanvasLayer/TextureRect.material.set_shader_parameter("resolution", viewport_size.x);
	$CanvasLayer/TextureRect.material.set_shader_parameter("scale", $Player/Camera2D.zoom*Vector2(1.0, viewport_size.x/viewport_size.y));
