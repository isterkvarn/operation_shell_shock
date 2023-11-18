extends Area2D

@export var speed: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.on_death_wall_collision()
	if body.is_in_group("enemies"):
		body.die()
