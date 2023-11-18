extends Area2D

const PLAYER_GROUP: String = "player"

var check_point_master: Node2D

func init(master: Node2D):
	check_point_master = master

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group(PLAYER_GROUP):
		check_point_master.save()
