extends CharacterBody3D

@export var speed = 6.5
@export var gravity = -10
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var player: CharacterBody3D


func _ready() -> void:
	$holder/AnimationPlayer.play("mixamo_com")
	$Timer.start()
	
	player = get_tree().get_first_node_in_group("player_group")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	$holder.rotation.x = 0
	
	
	
	if player:
		var target_pos = player.global_position
		$holder.look_at(Vector3(target_pos.x, $holder.global_position.y, target_pos.z))

	var dir = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	
	move_and_slide()


func make_path() -> void:
	if player:
		navigation_agent_3d.target_position = player.global_position


func _on_timer_timeout() -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player_group")
	
	if player:
		make_path()

func damage():
	queue_free() 


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_group"):
		body.damage()
	pass 
