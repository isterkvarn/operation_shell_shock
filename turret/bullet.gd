extends Area2D


var speed: float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta * cos(get_rotation())
	position.y += speed * delta * sin(get_rotation())


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hit_by_bullet()
	queue_free()
