extends Area2D


@export var speed: float = 2000

@onready var vacuum_audio = $AudioStreamPlayer2D

func _ready():
	vacuum_audio.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.on_death_wall_collision()
	if body.is_in_group("enemies"):
		body.die()
