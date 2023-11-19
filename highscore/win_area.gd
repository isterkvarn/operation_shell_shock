extends Area2D

@onready var highscore = load("res://highscore/highscore.tscn")
@onready var player = %Player
@onready var player_score = get_node("/root/PlayerScore")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == player:
		player_score.score = player.score
		get_tree().change_scene_to_file("res://highscore/highscore.tscn")
		
