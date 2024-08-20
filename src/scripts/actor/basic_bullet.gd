extends Area2D

var dt = 0;

func _ready():
	$AnimationPlayer.play("spawn");

func _physics_process(delta):
	var speed = 870.0*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD);
	var dir = Vector2.UP.rotated(rotation);
	position += dir * speed * delta;
	dt += speed * delta;
	if(dt > 1600 || GlobalStorage.isOutside(position)):
		queue_free();


func _on_body_entered(body):
	if(body.has_method("enemy_take_damage")):
		body.enemy_take_damage(6.0*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ATK));
		queue_free();
	pass # Replace with function body.
