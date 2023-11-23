extends Camera2D

@onready var player = $".."


func _physics_process(delta):
	position.x = player.global_position.x
