extends Node3D

var time_elapsed: float = 0.0
var game_running: bool = true 

@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var high_score_label: Label = $CanvasLayer/HighScoreLabel
@onready var zombie_spawn_timer: Timer = $ZombieSpawnTimer 

var player: CharacterBody3D

func _ready():
	player = get_tree().get_first_node_in_group("player_group")
	high_score_label.text = "High Score: " + str($ScoreManager.high_score)
	
	if player:
		player.player_died.connect(game_over)

func _process(delta: float):
	if not game_running:
		return
		
	time_elapsed += delta
	time_label.text = "Time: " + str(int(time_elapsed))

func game_over():
	
	zombie_spawn_timer.stop() 
	
	game_running = false
	
	$ScoreManager.check_and_set_high_score(int(time_elapsed))
	
	get_tree().reload_current_scene()


func _on_zombie_spawn_timer_timeout() -> void:
	
	if not game_running:
		return 
	
	var zombie_scene = preload("res://3D-Tutorial-Files-main/assets/Zombie/zombie.tscn")
	
	var new_zombie = zombie_scene.instantiate()
	
	var x_pos = randf_range(-30, 30) 
	var z_pos = randf_range(-30, 30) 
	new_zombie.global_position = Vector3(x_pos, 1, z_pos)
	
	new_zombie.add_to_group("enemy")
	
	add_child(new_zombie)

	new_zombie.scale = Vector3(15, 15, 15) 
	
	if "player" in new_zombie:
		new_zombie.player = player 
	else:
		print("!!! سكريبت الزومبي معندوش متغير اسمه player !!!")
