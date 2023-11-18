extends Node2D

# How much the death wall should move back from
# the checkpoint on a respawn
const DEATH_WALL_OFFSET: int = 6000
const BULLET_GROUP: String = "bullet"

@export var checkpoints: Array[Area2D]
@onready var bullet = load("res://turret/bullet.tscn")
@onready var player: CharacterBody2D = %Player
@onready var death_wall: Area2D = %DeathWall
var last_checkpoint: SaveState = null


class BulletState:
	var pos: Vector2
	var speed: float
	var rot: float
	
	func _init(pos: Vector2, speed: float, rot: float):
		self.pos = pos
		self.speed = speed
		self.rot = rot


class SaveState:
	var player: CharacterBody2D
	var death_wall: Area2D
	var player_pos: Vector2
	var bullet_pos: Array[BulletState]
	
	func _init(player: CharacterBody2D, death_wall: Area2D):
		self.player = player
		self.death_wall = death_wall
		self.player_pos = player.get_position()


func save():
	last_checkpoint = SaveState.new(player, death_wall)
	_save_children(get_tree().get_root())

func restore():
	if last_checkpoint == null:
		return
	
	player.position = last_checkpoint.player_pos
	death_wall.position.x = last_checkpoint.player_pos.x - DEATH_WALL_OFFSET
	_free_children(get_tree().get_root())
	_restore_children(get_tree().get_root())

# Called when the node enters the scene tree for the first time.
func _ready():
	for checkpoint in checkpoints:
		checkpoint.init(self)

func _save_children(node):
	if node.is_in_group(BULLET_GROUP):
		var bullet_state = BulletState.new(
			node.get_global_position(), 
			node.speed,
			node.get_rotation()
		)
		last_checkpoint.bullet_pos.append(bullet_state)

	for child in node.get_children():
		_save_children(child)

func _free_children(node):
	if node.is_in_group(BULLET_GROUP):
		node.queue_free()

	for child in node.get_children():
		_free_children(child)

func _restore_children(node):
	for bullet_state in last_checkpoint.bullet_pos:
		var bullet_scene = bullet.instantiate()
		bullet_scene.position = bullet_state.pos
		bullet_scene.speed = bullet_state.speed
		bullet_scene.rotation = bullet_state.rot
		add_child(bullet_scene)
