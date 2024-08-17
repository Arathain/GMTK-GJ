extends CanvasLayer

func _process(delta):
	var max = PlayerStorage.nextLevel;
	var su = PlayerStorage.components[0];
	var at = PlayerStorage.components[1];
	$MarginContainer/SustainBar.max_value = max;
	$MarginContainer/SustainBar.value = su;
	$MarginContainer/AttackBar.max_value = max;
	$MarginContainer/AttackBar.value = su+at;
	$MarginContainer/SpecialBar.max_value = max;
	$MarginContainer/SpecialBar.value = su+at+PlayerStorage.components[2];
