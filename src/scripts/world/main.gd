extends Node2D

@onready
var enemyInstance = preload("res://scenes/gameplay/enemy_cell.tscn");

@onready
var pauseMenu = $PauseScreen/Control
@onready
var upgradeMenu : UpgradeMenu = $UpgradeScreen/Control
var paused = false;

var cd := 0;


func _ready():
	SignalBus.levelUp.connect(levelUp);
	
func levelUp(type : GlobalStorage.CellType):
	upgradeMenu.show();
	get_tree().paused = true;
	upgradeMenu.chooseUpgrades(type);

func pause():
	if paused:
		pauseMenu.hide();
		get_tree().paused = false;
	else:
		pauseMenu.show();
		get_tree().paused = true;
	paused = !paused;

func _process(delta):
	if(Input.is_action_just_pressed("pause")):
		pause();
	var viewport = get_viewport()
	var viewport_size := viewport.get_visible_rect().size
	$CanvasLayer/TextureRect.material.set_shader_parameter("offset", Vector2($Player.position.x, $Player.position.y));
	$CanvasLayer/TextureRect.material.set_shader_parameter("resolution", viewport_size.x);
	$CanvasLayer/TextureRect.material.set_shader_parameter("scale", $Player/Camera2D.zoom*Vector2(1.0, viewport_size.x/viewport_size.y));
