extends CharacterBody2D


const IN_SHELL_SLOW = 30

@export var out_of_shell_speed = 800.0
@export var in_shell_speed = 800.0
@export var jump_velocity = 1600.0
@export var up_gravity_non_hold = 40
@export var up_gravity_hold = 40
@export var down_gravity = 40
@export var coyote_time = 0.1
@export var ground_friction = 5

var _current_speed : float = 0.0
var _is_in_shell : bool = false
var _coyote_timer : float

@onready var sprite = $AnimatedSprite2D
@onready var out_col = $CollisionShapeOut
@onready var in_col = $CollisionShapeIn
@onready var checkpoint_master: Node2D = %CheckPointMaster


func _ready():
	_current_speed = out_of_shell_speed


func _physics_process(delta):
	_update_state(Input.is_action_pressed("switch_state"))
	
	if _is_in_shell:
		_in_shell(delta)
	else:
		_out_of_shell(delta)
	
	_do_gravity()
	update_sprite()
	move_and_slide()


func _update_state(new_state):
	if new_state == _is_in_shell:
		return
	
	_is_in_shell = new_state
	if _is_in_shell:
		_current_speed = in_shell_speed
	else:
		_current_speed = out_of_shell_speed
	out_col.set_deferred("disabled", _is_in_shell)
	in_col.set_deferred("disabled", not _is_in_shell)


func _jump(delta):
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer -= delta
	
	if Input.is_action_just_pressed("ss_jump") and _coyote_timer > 0:
		velocity.y = -jump_velocity


func _out_of_shell(delta):
	_jump(delta)
	
	var _direction = Input.get_axis("ss_left", "ss_right")
	velocity.x = _direction * _current_speed


func _in_shell(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ground_friction * delta)


func _do_gravity():
	if is_on_floor():
		return
	
	if velocity.y >= 0:
		velocity.y += down_gravity
		return
	
	if Input.is_action_pressed("ss_jump"):
		velocity.y += up_gravity_hold
	else:
		velocity.y += up_gravity_non_hold


func bounce(speed: int):
	if _is_in_shell:	
		velocity.y = -speed
	else:
		die()


func hit_by_bullet():
	if not _is_in_shell:
		die()


func on_death_wall_collision():
	die()


func die():
	checkpoint_master.restore()


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
