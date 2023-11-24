extends Camera2D

var OFFSET_SPEED: int = 800
var MAX_X_OFFSET: float = 500
var MIN_X_OFFSET: float = -200
var X_LERP_WEIGHT: float = 0.25
var Y_LERP_WEIGHT: float = 0.05

var _x_offset: float = 0.0
var _camera_markers: Array[Marker2D]

@onready var player = $".."
@onready var _start_y = position.y


func _ready():
	for child in get_children():
		if child.is_in_group("camera_markers"):
			_camera_markers.append(child)


func _physics_process(delta):
	_x_offset += Input.get_axis("ss_left", "ss_right") * delta * OFFSET_SPEED
	_x_offset = clamp(_x_offset, MIN_X_OFFSET, MAX_X_OFFSET)
	
	position.x = lerp(position.x, player.global_position.x + _x_offset, X_LERP_WEIGHT)
	
	var new_y = _start_y
	for i in range(len(_camera_markers)):
		if _camera_markers[i].lerp and not i == len(_camera_markers):
			if player.position.x > _camera_markers[i].position.x and player.position.x < _camera_markers[i + 1].position.x:
				var marker_1_pos = _camera_markers[i].position
				var marker_2_pos = _camera_markers[i + 1].position
				var lerp_weight = (player.position.x - marker_1_pos.x) / (marker_2_pos.x - marker_1_pos.x)
				new_y = lerp(marker_1_pos.y, marker_2_pos.y, lerp_weight) 
				new_y -= 1080 * 0.5 / zoom.y
				break
		elif player.position.x > _camera_markers[i].position.x:
			new_y = _camera_markers[i].position.y - 1080 * 0.5 / zoom.y
	
	position.y = lerp(position.y, new_y, Y_LERP_WEIGHT)
