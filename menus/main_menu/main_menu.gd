extends Control


func _process(delta):
	if Input.is_action_just_pressed("start"):
#		get_tree().change_scene_to_file("res://main.tscn")
		get_tree().change_scene_to_file("res://levels/demo_level.tscn")
	
	if Input.is_action_just_pressed("highscores"):
		get_tree().change_scene_to_file("res://highscore/highscore.tscn")
