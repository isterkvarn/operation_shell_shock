extends Area2D


@export var speed: float = 2000.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.die()
