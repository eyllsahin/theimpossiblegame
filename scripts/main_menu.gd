# res://scripts/MainMenu.gd
extends Control

# If your buttons live under background/VBoxContainer, adjust paths here:
@onready var btn_play    = $background/VBoxContainer/characterselectbutton
@onready var btn_options = $background/VBoxContainer/optionsbutton
@onready var btn_quit    = $background/VBoxContainer/exitbutton

func _ready() -> void:
	btn_play   .pressed.connect(_on_btn_play_pressed)
	btn_options.pressed.connect(_on_btn_options_pressed)
	btn_quit   .pressed.connect(_on_btn_quit_pressed)

func _on_btn_play_pressed() -> void:
	# Godot 4 replacement for change_scene("…") / change_scene_to()
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_btn_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
