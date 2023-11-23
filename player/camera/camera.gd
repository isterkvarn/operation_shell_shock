extends Camera2D

var _offset_sensitivity: int = 500
var _x_offset: float = 0.0
var _max_x_offset: float = 500
var _min_x_offset: float = -200
var _x_lerp_weight: float = 0.25

@onready var player = $".."


func _physics_process(delta):
	_x_offset += Input.get_axis("ss_left", "ss_right") * delta * _offset_sensitivity
	_x_offset = clamp(_x_offset, _min_x_offset, _max_x_offset)
	
	
	
	position.x = lerp(position.x, player.global_position.x + _x_offset, _x_lerp_weight)
