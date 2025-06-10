# res://scripts/Learn.gd
extends Node2D

const CharacterSelectScene = preload("res://scenes/character_select.tscn")

func _ready() -> void:
	$btn_back.pressed.connect(Callable(self, "_on_btn_back_pressed"))

func _on_btn_back_pressed() -> void:
	get_tree().change_scene_to(CharacterSelectScene)
