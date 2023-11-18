extends Node2D

# How much the death wall should move back from
# the checkpoint on a respawn
const DEATH_WALL_OFFSET: int = 6000

@export var checkpoints: Array[Area2D]

@onready var player: CharacterBody2D = %Player
@onready var death_wall: Area2D = %DeathWall

var last_checkpoint: SaveState = null


class SaveState:
	var player: CharacterBody2D
	var death_wall: Area2D
	var player_pos: Vector2
	
	func _init(player: CharacterBody2D, death_wall: Area2D):
		self.player = player
		self.death_wall = death_wall
		self.player_pos = player.get_position()
	
	func restore():
		self.player.position = player_pos
		self.death_wall.position.x = player_pos.x - DEATH_WALL_OFFSET


func save():
	last_checkpoint = SaveState.new(player, death_wall)

func restore():
	if not last_checkpoint == null:
		last_checkpoint.restore()

# Called when the node enters the scene tree for the first time.
func _ready():
	for checkpoint in checkpoints:
		checkpoint.init(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
