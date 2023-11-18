extends CharacterBody2D

enum Facing {LEFT, RIGHT}

@export var facing: Facing = Facing.RIGHT

const SPEED = 500.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $"7up"

func _ready():
	velocity.x = SPEED

func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Wall collision
	if(is_on_wall()):
		change_direction()

	move_and_slide()
	
func _sprite_process():
	pass
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.on_enemy_collision(self)

func change_direction():
	facing = Facing.LEFT if facing == Facing.RIGHT else Facing.RIGHT
	velocity.x = SPEED if facing == Facing.RIGHT else -SPEED
	sprite.flip_h = facing == Facing.LEFT

func die():
	queue_free()
