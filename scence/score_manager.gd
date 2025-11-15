extends Node

const SAVE_PATH = "user://highscore.save"

var high_score: int = 0

func _ready():
	load_score()

func load_score():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		high_score = file.get_var()
		file.close()

func save_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()

func check_and_set_high_score(current_score: int):
	if current_score > high_score:
		high_score = current_score
		save_score() 
