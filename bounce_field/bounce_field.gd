extends Area2D

const PLAYER_GROUP: String = "player"

@export var speed: int = 5000
@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group(PLAYER_GROUP):
		body.bounce(speed)
