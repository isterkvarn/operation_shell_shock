extends Node2D

enum TurretMode {TRACK_PLAYER, POINT}
@export var firing_speed: float = 2.0
@export var bullet_speed: float = 15.0
@export var mode: TurretMode
@export var point: Marker2D

@onready var laser = load("res://turret/bullet.tscn")
@onready var sprite = $Sprite
@onready var player = %Player

var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if mode == TurretMode.POINT:
		if point == null:
			print("Add a marker to turret")
			return

		sprite.look_at(point.get_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode == TurretMode.TRACK_PLAYER:
		sprite.look_at(player.get_position())
	

	if (time > 1/firing_speed):
		time = 0
		_spawn_bullet()
	
	time += delta

func _spawn_bullet():
	var laser_scene = laser.instantiate()
	laser_scene.speed = bullet_speed

	if mode == TurretMode.TRACK_PLAYER:
		laser_scene.rotation = sprite.get_rotation()
	elif mode == TurretMode.POINT:
		if point == null:
			print("Add a marker to turret")
			return

		var direction: Vector2 = point.get_position() - get_position()
		var angle: float = atan2(direction.y, direction.x)
		laser_scene.rotation = angle

	add_child(laser_scene)
