extends CharacterBody2D

enum Facing {LEFT, RIGHT}

@export var facing: Facing = Facing.RIGHT
@export var speed: float = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite
@onready var left_edge_finder = $LeftEdgeFinder
@onready var right_edge_finder = $RightEdgeFinder

func _ready():
	velocity.x = speed
	sprite.play("default")

func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Wall collision
	if(is_on_wall()):
		change_direction()
		
	# Turn around when reaching end of platform
	if ((facing == Facing.LEFT and left_edge_finder.is_colliding() == false) or 
		(facing == Facing.RIGHT and right_edge_finder.is_colliding() == false)):
		change_direction()

	move_and_slide()

func _sprite_process():
	pass
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.on_enemy_collision(self)

func change_direction():
	facing = Facing.LEFT if facing == Facing.RIGHT else Facing.RIGHT
	velocity.x = speed if facing == Facing.RIGHT else -speed
	sprite.flip_h = facing == Facing.LEFT

func die():
	queue_free()
