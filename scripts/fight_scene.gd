extends Node2D

const GravitonScene = preload("res://scenes/graviton.tscn")
const QuantaScene   = preload("res://scenes/quanta.tscn")

@onready var fighters_container = $Fighters
@onready var spawn_left = $SpawnLeft
@onready var spawn_right = $SpawnRight

var player_character: CharacterBody2D
var enemy_character: CharacterBody2D
var camera: Camera2D

# UI elements
var player_health_bar: ProgressBar
var enemy_health_bar: ProgressBar
var ui_layer: CanvasLayer

func _ready() -> void:
	setup_ui()
	
	# Create camera
	camera = Camera2D.new()
	add_child(camera)
	
	# Clear any existing children in fighters container
	for child in fighters_container.get_children():
		child.queue_free()
	
	# Wait a frame
	await get_tree().process_frame
	
	# Create player and enemy based on selection
	var player_fighter
	var enemy_fighter
	
	if GameManager.chosen_character == "Graviton":
		player_fighter = GravitonScene.instantiate()
		enemy_fighter = QuantaScene.instantiate()
	else:
		player_fighter = QuantaScene.instantiate()
		enemy_fighter = GravitonScene.instantiate()
	
	# Setup player (always spawns on left)
	player_fighter.is_player_controlled = true
	player_fighter.global_position = spawn_left.global_position
	
	# Setup enemy AI (always spawns on right)
	enemy_fighter.is_player_controlled = false
	enemy_fighter.global_position = spawn_right.global_position
	
	# Add to scene
	fighters_container.add_child(player_fighter)
	fighters_container.add_child(enemy_fighter)
	
	# Flip enemy to face left
	enemy_fighter.sprite.flip_h = true
	
	# Store references
	player_character = player_fighter
	enemy_character = enemy_fighter
	
	print("Player spawned at: ", player_character.global_position)
	print("Enemy spawned at: ", enemy_character.global_position)

func setup_ui():
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	# Player health bar (left side)
	player_health_bar = ProgressBar.new()
	player_health_bar.size = Vector2(300, 30)
	player_health_bar.position = Vector2(50, 50)
	player_health_bar.max_value = 100
	player_health_bar.value = 100
	player_health_bar.modulate = Color.RED
	ui_layer.add_child(player_health_bar)
	
	# Enemy health bar (right side)
	enemy_health_bar = ProgressBar.new()
	enemy_health_bar.size = Vector2(300, 30)
	enemy_health_bar.position = Vector2(930, 50)
	enemy_health_bar.max_value = 100
	enemy_health_bar.value = 100
	enemy_health_bar.modulate = Color.BLUE
	ui_layer.add_child(enemy_health_bar)
	
	# Labels
	var player_label = Label.new()
	player_label.text = "Player"
	player_label.position = Vector2(50, 30)
	ui_layer.add_child(player_label)
	
	var enemy_label = Label.new()
	enemy_label.text = "Enemy"
	enemy_label.position = Vector2(930, 30)
	ui_layer.add_child(enemy_label)

func _process(delta: float) -> void:
	if player_character and enemy_character and camera:
		# Update health bars
		player_health_bar.value = player_character.current_health
		enemy_health_bar.value = enemy_character.current_health
		
		# Check for game over
		if player_character.is_dead or enemy_character.is_dead:
			handle_game_over()
		
		# Center camera between both characters
		var center_pos = (player_character.global_position + enemy_character.global_position) / 2
		camera.global_position = camera.global_position.lerp(center_pos, 3.0 * delta)

func handle_game_over():
	# Wait a bit then return to character select
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
