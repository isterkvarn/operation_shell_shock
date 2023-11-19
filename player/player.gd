extends CharacterBody2D


@export var out_of_shell_speed = 1200.0
@export var in_shell_speed = 400.0
@export var jump_velocity = 1600.0
@export var up_gravity_non_hold = 100.0
@export var up_gravity_hold = 50.0
@export var down_gravity = 160.0
@export var coyote_time = 0.1
@export var ground_friction = 750

var _current_speed : float = 0.0
var _is_in_shell : bool = false
var _coyote_timer : float
var score: float = 0.0
var buffer_jump: bool = false

@onready var sprite = $AnimatedSprite2D
@onready var out_col = $CollisionShapeOut
@onready var in_col = $CollisionShapeIn
@onready var checkpoint_master: Node2D = %CheckPointMaster
@onready var camera_2d = $Camera2D
@onready var roof_finder1 = $RoofRayCast1
@onready var roof_finder2 = $RoofRayCast2
@onready var wall_finder1 = $WallRayCast1
@onready var wall_finder2 = $WallRayCast2

#@onready var jump_audio = $JumpAudio
@onready var switch_audio = $SwitchAudio
@onready var score_indicator = $Camera2D/ScoreIndicator


func _ready():
	_current_speed = out_of_shell_speed


func _process(delta):
	_update_score(delta)


func _physics_process(delta):
	if Input.is_action_just_pressed("switch_state"):
		switch_audio.play()
	
	if not _is_under_roof():
		_update_state(Input.is_action_pressed("switch_state"))
	
	if _is_under_roof() and abs(velocity.x) < 0.05:
		if velocity.x >= 0:
			velocity.x = 30
		else:
			velocity.x = -30
		
	if Input.is_action_just_pressed("ss_jump"):
		buffer_jump = true
	
	if _is_in_shell:
		_in_shell(delta)
	else:
		_out_of_shell(delta)
	
	_do_gravity()
	update_sprite()
	move_and_slide()


func _update_score(delta):
	score += delta
	# I don't have the energy to look up rounding functions in Godot
	score_indicator.text = str(int(score * 100)/100.0)

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
	
	if buffer_jump and _coyote_timer > 0:
		#jump_audio.play()
		buffer_jump = false
		velocity.y = -jump_velocity


func _out_of_shell(delta):
	_jump(delta)
	
	var _direction = Input.get_axis("ss_left", "ss_right")
	velocity.x = _direction * _current_speed


func _in_shell(delta):
	if is_on_floor() and not _is_under_roof():
		velocity.x = move_toward(velocity.x, 0, ground_friction * delta)

func _is_under_roof() -> bool:
	return (
		(roof_finder1.is_colliding() or 
		roof_finder2.is_colliding()) and
		not wall_finder1.is_colliding() and
		not wall_finder2.is_colliding()
	)

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
	
func on_enemy_collision(enemy):
	if not _is_in_shell:
		die()
		return
	
	# If shelled with little to no momentum, the enemy turns around
	if(velocity.length() < 300):
		enemy.change_direction()
		return

	# Kill if fast!!
	enemy.die()
	
	# Do the bounce
	velocity.x *= 0.35
	
	if(velocity.y > 0):
		velocity.y *= -0.75

func die():
	checkpoint_master.restore()

func update_sprite():
	if not velocity.x == 0:
		sprite.flip_h = velocity.x < 0
		if camera_2d.updates_flip:
			camera_2d.is_following_right = not sprite.flip_h
	
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
