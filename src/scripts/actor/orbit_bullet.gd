extends Area2D

var hurt_cd:= 0.0;

func _physics_process(delta):
	if hurt_cd > 0.0:
		hurt_cd = max(0.0, hurt_cd-1.0/30.0*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD));

func _process(delta):
	$Sprite2D.modulate.g = 1.0-hurt_cd*0.6;
	$Sprite2D.modulate.r = 1.0-hurt_cd*0.4;
	$Sprite2D.modulate.b = 1.0-hurt_cd*0.3;

func _on_body_entered(body):
	if(body.has_method("enemy_take_damage")):
		body.enemy_take_damage((5.0+float(PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ORBIT))*0.5)*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ATK));
		hurt_cd = 1.0;
	pass # Replace with function body.
