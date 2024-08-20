extends Node

var cursorLoad = load("res://assets/texture/cursor/Outline/pointer_k.svg")

var loading_scene = preload("res://scenes/loading_screen.tscn")

var next_scene : String = ""
var cursor = false;

func loadSceneTransition(next : String):
	loadSceneTrans(next, false);
	
func loadSceneTrans(next : String, cursorIn : bool):
	next = "res://scenes/" + next + ".tscn";
	cursor = cursorIn;
	next_scene = next;
	get_tree().change_scene_to_packed(loading_scene);
	
func runPost():
	if (cursor): 
		Input.set_custom_mouse_cursor(cursorLoad, 0, Vector2(0, 0)); 

var maxDist := 3475.0;

func clampPos(vec : Vector2):
	return Vector2(clamp(vec.x, -maxDist, maxDist), clamp(vec.y, -maxDist, maxDist));

func clampPosBuffer(vec : Vector2, buffer : float):
	return Vector2(clamp(vec.x, -maxDist+buffer, maxDist-buffer), clamp(vec.y, -maxDist+buffer, maxDist-buffer));

func isOutside(vec : Vector2):
	return vec.x > maxDist || vec.x < -maxDist || vec.y > maxDist || vec.y < -maxDist;

func cellTypeStr(type : CellType):
	return CellType.keys()[type].to_lower();

enum CellType {
	SUSTAIN,
	ATTACK,
	SPECIAL
}

