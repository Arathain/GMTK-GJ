extends AudioStreamPlayer2D


func _on_finished():
	play();

func _process(delta):
	if(get_tree().paused):
		volume_db = -10;
	else:
		volume_db = -2;
