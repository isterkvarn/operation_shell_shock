extends Node2D

const SPEED: float = 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += SPEED * cos(get_rotation())
	position.y += SPEED * sin(get_rotation())
