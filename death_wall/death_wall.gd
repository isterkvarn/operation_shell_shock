extends Area2D

@export var speed: float = 5.0

@onready var checkpoint_master: Node2D = %CheckPointMaster

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed


func _on_body_entered(body):
	if body.is_in_group("player"):
		checkpoint_master.restore()
