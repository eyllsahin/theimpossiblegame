# res://scripts/CharacterSelect.gd
extends Node2D

# Preload the scenes we’ll switch between:
const MainMenuScene = preload("res://scenes/main_menu.tscn")
const LearnQuantaScene    = preload("res://scenes/learn_quanta.tscn")
const LearnGravitonScene    = preload("res://scenes/learn_graviton.tscn")
const FightScene    = preload("res://scenes/fight_scene.tscn")

func _ready() -> void:
	# — Selection Buttons —
	$CanvasLayer/characterselectbutton .pressed.connect(_on_btn_graviton_pressed)
	$CanvasLayer/characterselectbutton2.pressed.connect(_on_btn_quanta_pressed)
	$CanvasLayer/backbutton           .pressed.connect(_on_btn_back_pressed)
	
	# — Learn Buttons (one per character) —
	$CanvasLayer/learnquanta    .pressed.connect(_on_btn_learn_quanta_pressed)
	$CanvasLayer/learngraviton  .pressed.connect(_on_btn_learn_graviton_pressed)

	# — Hover-to-play callbacks on your CanvasLayer —
	$CanvasLayer/timedilation   .mouse_entered.connect(_on_timedilation_hover)
	$CanvasLayer/timedilation   .mouse_exited.connect(_on_timedilation_unhover)
	$CanvasLayer/eventhorizon   .mouse_entered.connect(_on_eventhorizon_hover)
	$CanvasLayer/eventhorizon   .mouse_exited.connect(_on_eventhorizon_unhover)
	$CanvasLayer/evasion        .mouse_entered.connect(_on_evasion_hover)
	$CanvasLayer/evasion        .mouse_exited.connect(_on_evasion_unhover)
	$CanvasLayer/counter        .mouse_entered.connect(_on_counter_hover)
	$CanvasLayer/counter        .mouse_exited.connect(_on_counter_unhover)

# — Button callbacks —

func _on_btn_graviton_pressed() -> void:
	GameManager.chosen_character = "Graviton"
	get_tree().change_scene_to_packed(FightScene)

func _on_btn_quanta_pressed() -> void:
	GameManager.chosen_character = "Quanta"
	get_tree().change_scene_to_packed(FightScene)

func _on_btn_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_btn_learn_quanta_pressed() -> void:
	get_tree().change_scene_to_packed(LearnQuantaScene)

func _on_btn_learn_graviton_pressed() -> void:
	get_tree().change_scene_to_packed(LearnGravitonScene)


# — Hover-preview helpers —

func _stop_all_videos() -> void:
	for video_name in ["timebend2", "eventhorizon2", "evasion2", "counter2"]:
		var vs = $CanvasLayer.get_node(video_name) as VideoStreamPlayer
		vs.visible = false
		vs.stop()

func _on_timedilation_hover() -> void:
	_stop_all_videos()
	$CanvasLayer/timebend2.visible = true
	$CanvasLayer/timebend2.play()
func _on_timedilation_unhover() -> void:
	$CanvasLayer/timebend2.visible = false
	$CanvasLayer/timebend2.stop()

func _on_eventhorizon_hover() -> void:
	_stop_all_videos()
	$CanvasLayer/eventhorizon2.visible = true
	$CanvasLayer/eventhorizon2.play()
func _on_eventhorizon_unhover() -> void:
	$CanvasLayer/eventhorizon2.visible = false
	$CanvasLayer/eventhorizon2.stop()

func _on_evasion_hover() -> void:
	_stop_all_videos()
	$CanvasLayer/evasion2.visible = true
	$CanvasLayer/evasion2.play()
func _on_evasion_unhover() -> void:
	$CanvasLayer/evasion2.visible = false
	$CanvasLayer/evasion2.stop()

func _on_counter_hover() -> void:
	_stop_all_videos()
	$CanvasLayer/counter2.visible = true
	$CanvasLayer/counter2.play()
func _on_counter_unhover() -> void:
	$CanvasLayer/counter2.visible = false
	$CanvasLayer/counter2.stop()
