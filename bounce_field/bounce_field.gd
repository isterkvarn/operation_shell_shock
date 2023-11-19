extends Area2D


const PLAYER_GROUP: String = "player"

@export var speed: int = 3000
@onready var player = %Player
@onready var sprite = $Sprite
@onready var sprite2 = $Sprite2

func _ready():
	sprite.play('default')
	sprite2.play('default')

func _on_body_entered(body):
	if body.is_in_group(PLAYER_GROUP):
		body.bounce(speed)
