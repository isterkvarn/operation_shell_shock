extends CharacterBody2D


@export var out_of_shell_speed = 800.0
@export var in_shell_speed = 800.0

@export var jump_velocity = 1600.0
@export var up_gravity = 9
@export var down_gravity = 9
@export var coyote_time = 0.1

var _current_speed : float = 0.0
var _is_in_shell : bool = false
var _coyote_timer : float

@onready var debug_color_rect_out_of_shell = $DebugColorRectOutOfShell
@onready var debug_color_rect_in_shell = $DebugColorRectInShell


func _ready():
	_current_speed = out_of_shell_speed


func _physics_process(delta):
	if Input.is_action_just_pressed("switch_state"):
		_switch_state()
	
	if _is_in_shell:
		_in_shell()
	else:
		_out_of_shell(delta)
	
	
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += up_gravity
		else:
			velocity.y += down_gravity
	
	move_and_slide()


func _switch_state():
	_is_in_shell = not _is_in_shell
	if _is_in_shell:
		debug_color_rect_in_shell.show()
		debug_color_rect_out_of_shell.hide()
		_current_speed = in_shell_speed
	else:
		debug_color_rect_in_shell.hide()
		debug_color_rect_out_of_shell.show()
		_current_speed = out_of_shell_speed


func _jump(delta):
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer -= delta
	
	if Input.is_action_just_pressed("ss_jump") and _coyote_timer > 0:
		velocity.y = -jump_velocity


func _out_of_shell(delta):
	
	_jump(delta)
	
	var direction = Input.get_axis("ss_left", "ss_right")
	velocity.x = direction * _current_speed


func _in_shell():
	var direction = Input.get_axis("ss_left", "ss_right")
#	velocity.x = direction * _current_speed
