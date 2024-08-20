extends Control

var targetScore := 0;
@onready
var flerp := 0.0


func initScore(score : float):
	targetScore = score;

func _physics_process(delta):
	if(targetScore > 0):
		flerp = minf(flerp+delta*0.5, 1.0);

func _process(delta):
	$MarginContainer/VBoxContainer/Score.text = "Score: " + str(int(lerp(0, targetScore, flerp)))

func _on_save__quit_pressed():
	get_tree().paused = false;
	GlobalStorage.loadSceneTransition("menu");


func _on_resume_pressed():
	get_tree().paused = false;
	GlobalStorage.loadSceneTrans("gameplay/main", true);
