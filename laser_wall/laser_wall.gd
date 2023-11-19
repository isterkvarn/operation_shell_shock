extends Area2D

const PLAYER_GROUP: String = "player"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()

func _on_body_entered(body):
	if body == player:
		player.hit_by_bullet() # this is a bullet, yes
