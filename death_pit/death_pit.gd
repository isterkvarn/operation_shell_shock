extends Area2D

@onready var checkpoint_master: Node2D = %CheckPointMaster

func _on_body_entered(body):
	if body.is_in_group("player"):
		checkpoint_master.restore()
