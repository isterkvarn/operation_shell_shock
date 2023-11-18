extends Area2D

@onready var checkpoint_master: Node2D

var speed: float

func set_checkpoint_master(master: Node2D):
	checkpoint_master = master

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * cos(get_rotation())
	position.y += speed * sin(get_rotation())


func _on_body_entered(body):
	if body.is_in_group("player"):
		checkpoint_master.restore()
	queue_free()
