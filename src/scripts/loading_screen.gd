extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(GlobalStorage.next_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var prog = []
	ResourceLoader.load_threaded_get_status(GlobalStorage.next_scene, prog);
	$ProgressBar.value = prog[0] * 100;
	
	if prog[0] == 1:
		var packed = ResourceLoader.load_threaded_get(GlobalStorage.next_scene);
		get_tree().change_scene_to_packed(packed);
		GlobalStorage.runPost();
