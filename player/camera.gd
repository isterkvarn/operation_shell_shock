extends Camera2D


@export var max_speed : float = 2000.0
@export var distance_sensitivity : float = 5
@export var wiggle_room : float = 200.0

var is_following_right : bool = false
var updates_flip : bool = true

var _current_x_speed : float
var _current_y_speed : float
var _last_still_x : float = 0.0

@onready var _camera_anchor_right = $"../CameraAnchorRight"
@onready var _camera_anchor_left = $"../CameraAnchorLeft"
@onready var player = $".."
@onready var _player_start_y = player.position.y
@onready var _start_y = _camera_anchor_right.position.y


func _physics_process(delta):
	if player.velocity.x == 0:
		_last_still_x = player.position.x
		updates_flip = false
	else:
		updates_flip = (abs(player.position.x - _last_still_x) > wiggle_room)
	
	var _y_aim = _player_start_y + _start_y
	if player.position.y < 130:
		_y_aim -= 450
	
	var _x_aim : float
	if is_following_right:
		_x_aim = _camera_anchor_right.global_position.x
	else:
		_x_aim = _camera_anchor_left.global_position.x
	
	var _x_diff = abs(_x_aim - position.x)
	var _y_diff = abs(_y_aim - position.y)
	
	_current_x_speed = _x_diff * distance_sensitivity #min(max_speed, _x_diff * distance_sensitivity)
	_current_y_speed = _y_diff * distance_sensitivity #min(max_speed, _y_diff * distance_sensitivity)
	position.x = move_toward(position.x, _x_aim, _current_x_speed * delta)
	position.y = move_toward(position.y, _y_aim, _current_y_speed * delta)
