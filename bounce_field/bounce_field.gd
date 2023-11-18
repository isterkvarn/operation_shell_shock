extends Area2D


const PLAYER_GROUP: String = "player"

@export var speed: int = 3000
@onready var player = %Player


func _on_body_entered(body):
	if body.is_in_group(PLAYER_GROUP):
		body.bounce(speed)
