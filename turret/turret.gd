extends Node2D


enum TurretMode {TRACK_PLAYER, POINT}

@export var firing_speed: float = 0.5
@export var bullet_speed: float = 1200.0
@export var mode: TurretMode
@export var point: Marker2D

@onready var laser = load("res://turret/bullet.tscn")
@onready var base_sprite = $TurretBase
@onready var barrel = $Barrel
@onready var player = %Player
@onready var shoot_audio = $AudioStreamPlayer2D

var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if mode == TurretMode.POINT:
		if point == null:
			print("Add a marker to turret")
			return

		barrel.look_at(point.get_position())
		var r = barrel.get_rotation()
		barrel.flip_v = (r > PI / 2 or r < -PI / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_sprite()
	_update_shooting_interval(delta)
	
func _update_shooting_interval(delta):
	if (time > 1 / firing_speed):
		time = 0
		_do_the_shooty()
		shoot_audio.play()
	
	time += delta
	
func _update_sprite():
	pass
	if mode == TurretMode.TRACK_PLAYER:
		barrel.look_at(player.get_position())
		var deg = int(barrel.get_rotation() * 57.3)	 % 360 #convert rad to deg 
		print(deg)
		barrel.flip_v = (deg > 90 and deg < 270) or (deg < 90 and deg > 270)
		#barrel_sprite.flip_v = (r > PI / 2 or r < -PI / 2)

func _do_the_shooty():
	barrel.play("the_shooty") 
	_spawn_bullet()

func _spawn_bullet():
	var laser_scene = laser.instantiate()
	laser_scene.speed = bullet_speed

	if mode == TurretMode.TRACK_PLAYER:
		laser_scene.rotation = barrel.get_rotation()
	elif mode == TurretMode.POINT:
		if point == null:
			print("Add a marker to turret")
			return

		var direction: Vector2 = point.get_position() - get_position()
		var angle: float = atan2(direction.y, direction.x)
		laser_scene.rotation = angle

	add_child(laser_scene)
