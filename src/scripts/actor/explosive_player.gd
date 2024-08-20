extends Area2D

var dt = 0;
var deathcd = -1;

@onready
var _animated_sprite := $AnimatedSprite2D;
@onready
var exparea := $Area2D;

func _ready():
	_animated_sprite.play("idle");
	($Area2D/ExplosionShape.shape as CircleShape2D).radius = PlayerStorage.getValue(PlayerStorage.UpgradeType.EXPLODE);
	($GPUParticles2D.process_material as ParticleProcessMaterial).scale_min = 110/PlayerStorage.getValue(PlayerStorage.UpgradeType.EXPLODE);

func _physics_process(delta):
	if(deathcd >= 0):
		deathcd -= 1;
	if (!_animated_sprite.animation.contains("explode") && deathcd == -1):
		var speed = 620.0*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ABSPD);
		var dir = Vector2.UP.rotated(rotation);
		position += dir * speed * delta;
		dt += speed * delta;
	if(GlobalStorage.isOutside(position)):
		queue_free();
	if(dt > 2400):
		explode();
	if(deathcd == 0):
		queue_free();

func explode():
	_animated_sprite.play("explode");
	
func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation.contains("explode"):
		for body in exparea.get_overlapping_bodies():
			if(body.has_method("enemy_take_damage")):
				body.enemy_take_damage(30.0*PlayerStorage.getDecimal(PlayerStorage.UpgradeType.ATK));
		deathcd = 120;
		$GPUParticles2D.emitting = true;
		$AudioStreamPlayer2D.play();
	else:
		_animated_sprite.play("idle");

func _on_body_entered(body):
	if(deathcd == -1 && body.has_method("enemy_take_damage")):
		explode();
	pass # Replace with function body.
