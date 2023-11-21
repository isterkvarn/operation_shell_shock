extends Control

const SAVE_FILE: String = "user://higahaaasacores.dat"
const PADDING: int = 30
const MAX_NAME_LENGTH: int = 16

@onready var names_box = $Panel/Names
@onready var name_input = $Panel/NameInput
@onready var score_text = $Panel/Score
@onready var ok_button = $Panel/Button
@onready var start_label = $Panel/StartLabel
@onready var player_score = get_node("/root/PlayerScore")
@onready var http = $HTTPRequest

class ScoreData:
	var name: String
	var score: float

	func _init(name: String, score: float):
		self.name = name
		self.score = score

	func from_json(json):
		self.name = json["name"]
		self.score = json["score"]

	func to_json():
		return {
			"name": name,
			"score": score
		}

var scores: Array[ScoreData]

func _ready():
	names_box.visible = false
	
	_from_disk()
	add_score(player_score.score)
	
	if scores.size() == 0:
		_add_score("Moa", 50.33)
		_add_score("Zoe", 56.53)
		_add_score("Malte", 81.51)
		_add_score("Emanuel", 104.83)
		_add_score("Gurka2", 122.02)

func add_score(score: float):
	if score == 0:
		name_input.visible = false
		score_text.visible = false
		names_box.visible = true
		ok_button.visible = false
		start_label.visible = true
		_populate_name_box()
		http.get_scores(_on_response)
		

	score_text.text = str(int(score*100)/100.0)

func _add_score(name: String, score: float):
	var new_score: ScoreData = ScoreData.new(name, score)
	http.new_score(name, score, _on_response)

	for i in range(scores.size()):
		var old_score: ScoreData = scores[i]
		
		if old_score.score > new_score.score:
			scores.insert(i, new_score)
			_to_disk()
			return

	scores.append(new_score)
	_to_disk()

func _process(delta):
	if Input.is_action_just_pressed("start"):
#		get_tree().change_scene_to_file("res://main.tscn")
		get_tree().change_scene_to_file("res://levels/demo_level.tscn")

func _to_disk():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(_to_json())

func _from_disk():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	
	if file == null:
		_to_disk()
		file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	
	var json = JSON.parse_string(file.get_as_text())
	scores = []
	
	for entry in json:
		scores.append(ScoreData.new(
			entry["name"],
			entry["score"]
		))

func _to_json() -> String:
	var score_json = []
	
	for score_data in scores:
		score_json.append(score_data.to_json())
	
	return JSON.stringify(score_json)


func _on_name_input_text_changed(new_text):
	if len(new_text) > MAX_NAME_LENGTH:
		name_input.text = new_text.left(MAX_NAME_LENGTH)

func _populate_name_box():
	for score in scores:
		names_box.text += score.name
		for i in range(PADDING - len(score.name)):
			names_box.text += " "
		
		names_box.text += str(int(score.score*100)/100.0) + "\n"

func _on_response(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code == 201:
		http.get_scores(_on_response)
	
	if not response_code == 200:
		return
		
	names_box.text = ""

	for score in json:
		names_box.text += score["name"]
		for i in range(PADDING - len(score["name"])):
			names_box.text += " "
		
		names_box.text += str(int(score["score"]*100)/100.0) + "\n"

func _on_button_pressed():
	if len(name_input.text) == 0:
		return
	
	_add_score(name_input.text, float(score_text.text))
	_populate_name_box()
	
	name_input.visible = false
	score_text.visible = false
	names_box.visible = true
	ok_button.visible = false
	start_label.visible = true
