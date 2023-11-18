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

@onready var sprite = $AnimatedSprite2D

const IN_SHELL_SLOW = 1500


func _ready():
	_current_speed = out_of_shell_speed


func _physics_process(delta):
	if Input.is_action_just_pressed("switch_state"):
		_switch_state()
	
	if _is_in_shell:
		_in_shell(delta)
	else:
		_out_of_shell(delta)
	
	
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += up_gravity
		else:
			velocity.y += down_gravity
			
	update_sprite()
	
	move_and_slide()


func _switch_state():
	_is_in_shell = not _is_in_shell
	if _is_in_shell:
		_current_speed = in_shell_speed
	else:
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


func _in_shell(delta):
	#var direction = Input.get_axis("ss_left", "ss_right")
#	velocity.x = direction * _current_speed
	if velocity.x != 0 and is_on_floor():
		velocity.x -= velocity.x/abs(velocity.x) * IN_SHELL_SLOW * delta
		
	if velocity.x > -IN_SHELL_SLOW*delta*2 and velocity.x < IN_SHELL_SLOW*delta*2:
		velocity.x = 0

func hit_by_bullet():
	if not _is_in_shell:
		_die()
		
func on_death_wall_collision():
	_die()

func _die():
	get_tree().reload_current_scene()

		
func update_sprite():
	
	sprite.flip_h = velocity.x < 0
	
	if _is_in_shell:
		if sprite.animation != "shell":
			sprite.play("shell")
		return
	
	if velocity.x != 0:
		sprite.play("run")
	else:
		sprite.play("idel")
	
	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("fall")
		else:
			sprite.play("jump")
